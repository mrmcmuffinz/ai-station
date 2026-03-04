#!/usr/bin/env bash
# ollama-latency-bench.sh — Diagnose where Ollama response latency comes from
#
# Usage: ./ollama-latency-bench.sh [model]
#   model: defaults to qwen3.5:9b (most VRAM-efficient model on box01)
#
# This script isolates three layers of the request path:
#   Browser → Open WebUI → Ollama API → GPU inference
#
# It tests from the bottom up so you can see exactly where time is spent.

set -euo pipefail

# --- Configuration ---
MODEL="${1:-qwen3.5:9b}"
OLLAMA_URL="http://localhost:11434"
PROMPT="Explain what a container namespace is in two sentences."

# --- Smart Color Logic ---
if [ -t 1 ]; then
  CYAN='\033[0;36m'
  GREEN='\033[0;32m'
  YELLOW='\033[1;33m'
  RED='\033[0;31m'
  BOLD='\033[1m'
  RESET='\033[0m'
else
  CYAN=''
  GREEN=''
  YELLOW=''
  RED=''
  BOLD=''
  RESET=''
fi

header() { printf "\n${BOLD}${CYAN}━━━ %s ━━━${RESET}\n\n" "$1"; }
info()   { printf "${GREEN}▸${RESET} %s\n" "$1"; }
warn()   { printf "${YELLOW}▸${RESET} %s\n" "$1"; }
label()  { printf "  ${BOLD}%-24s${RESET} %s\n" "$1" "$2"; }

ns_to_ms() {
  # Convert nanoseconds to milliseconds with 1 decimal place
  awk "BEGIN { printf \"%.1f\", $1 / 1000000 }"
}

ns_to_sec() {
  # Convert nanoseconds to seconds with 2 decimal places
  awk "BEGIN { printf \"%.2f\", $1 / 1000000000 }"
}

# New Helper Function for Test Descriptions
# Usage: block "What" "Why" "Expect" "Description of what's happening..."
block() {
  printf "${BOLD}%-8s${RESET} %s\n" "What:" "$1"
  printf "${BOLD}%-8s${RESET} %s\n" "Why:" "$2"
  printf "${BOLD}%-8s${RESET} %s\n\n" "Expect:" "$3"
}

# --- Preflight ---
header "PREFLIGHT CHECKS"

info "Checking Ollama is reachable at ${OLLAMA_URL}..."
if ! curl -sf "${OLLAMA_URL}/api/tags" > /dev/null 2>&1; then
  printf "${RED}ERROR:${RESET} Cannot reach Ollama at ${OLLAMA_URL}\n"
  printf "  Is the ollama container running? Check: nerdctl compose ps\n"
  exit 1
fi
info "Ollama is up."

info "Checking model '${MODEL}' is available..."
if ! curl -sf "${OLLAMA_URL}/api/tags" | jq -e ".models[] | select(.name == \"${MODEL}\")" > /dev/null 2>&1; then
  # Try matching without :latest suffix normalization
  AVAILABLE=$(curl -sf "${OLLAMA_URL}/api/tags" | jq -r '.models[].name' 2>/dev/null)
  printf "${RED}ERROR:${RESET} Model '${MODEL}' not found.\n"
  printf "  Available models:\n"
  echo "${AVAILABLE}" | sed 's/^/    /'
  exit 1
fi
info "Model '${MODEL}' is available."

# --- Test 1: Check what's currently loaded ---
header "TEST 1 — CURRENTLY LOADED MODELS"

block \
  "Check if any model is already resident in VRAM." \
  "If nothing is loaded, the first prompt will pay a cold-start penalty while weights are read from disk into GPU memory." \
  "If you haven't prompted recently, this will likely be empty."

LOADED=$(curl -sf "${OLLAMA_URL}/api/ps")
LOADED_COUNT=$(echo "${LOADED}" | jq '.models | length')

if [ "${LOADED_COUNT}" -eq 0 ]; then
  warn "No models currently loaded. First request WILL be a cold start."
else
  info "Models currently in VRAM:"
  echo "${LOADED}" | jq -r '.models[] | "  \(.name)  size_vram=\(.size_vram)  expires=\(.expires_at)"'
fi

# --- Test 2: Cold start (force unload first) ---
header "TEST 2 — COLD START (Model Load from Disk → VRAM)"

block \
  "Force-unload the model, then send a prompt. This measures the worst-case latency: reading weights from disk into VRAM + inference." \
  "Ollama unloads models after 5 min idle by default. If you see long pauses on first prompts after a break, this is the cause." \
  "load_duration will be large (2–15 seconds depending on model size). A 9B Q4 model typically loads in 2–5s from SSD."

info "Unloading ${MODEL} from VRAM..."
curl -sf "${OLLAMA_URL}/api/generate" -d "{\"model\": \"${MODEL}\", \"keep_alive\": 0}" > /dev/null 2>&1 || true
sleep 2

info "Sending cold prompt: \"${PROMPT}\""
info "This may take a while — model must load first..."
echo ""

COLD_START=$(date +%s%N)
COLD_RESPONSE=$(curl -sf "${OLLAMA_URL}/api/generate" -d "{\"model\": \"${MODEL}\", \"prompt\": \"${PROMPT}\", \"stream\": false}")
COLD_END=$(date +%s%N)
COLD_WALL=$(( (COLD_END - COLD_START) / 1000000 ))

COLD_LOAD=$(echo "${COLD_RESPONSE}" | jq -r '.load_duration // 0')
COLD_PROMPT_EVAL=$(echo "${COLD_RESPONSE}" | jq -r '.prompt_eval_duration // 0')
COLD_EVAL=$(echo "${COLD_RESPONSE}" | jq -r '.eval_duration // 0')
COLD_EVAL_COUNT=$(echo "${COLD_RESPONSE}" | jq -r '.eval_count // 0')
COLD_PROMPT_COUNT=$(echo "${COLD_RESPONSE}" | jq -r '.prompt_eval_count // 0')

if [ "${COLD_EVAL_COUNT}" -gt 0 ]; then
  COLD_TPS=$(awk "BEGIN { printf \"%.1f\", ${COLD_EVAL_COUNT} / (${COLD_EVAL} / 1000000000) }")
else
  COLD_TPS="N/A"
fi

printf "${BOLD}Cold Start Results:${RESET}\n"
label "Wall clock:" "${COLD_WALL} ms"
label "Model load (disk→VRAM):" "$(ns_to_ms ${COLD_LOAD}) ms  ($(ns_to_sec ${COLD_LOAD}) s)"
label "Prompt eval (prefill):" "$(ns_to_ms ${COLD_PROMPT_EVAL}) ms  (${COLD_PROMPT_COUNT} tokens)"
label "Generation (decode):" "$(ns_to_ms ${COLD_EVAL}) ms  (${COLD_EVAL_COUNT} tokens)"
label "Tokens/sec (decode):" "${COLD_TPS} t/s"
label "Overhead (wall - sum):" "$(( COLD_WALL - $(awk "BEGIN { printf \"%d\", (${COLD_LOAD} + ${COLD_PROMPT_EVAL} + ${COLD_EVAL}) / 1000000 }") )) ms"

# --- Test 3: Warm inference ---
header "TEST 3 — WARM INFERENCE (Model Already in VRAM)"

block \
  "Send the same prompt again immediately. The model is still loaded in VRAM from Test 2, so there's no load penalty." \
  "This isolates pure inference speed — the baseline your users experience when the model is warm." \
  "load_duration should be near zero. Total time should be dramatically faster than the cold start."

info "Sending warm prompt (model should be resident)..."
echo ""

WARM_START=$(date +%s%N)
WARM_RESPONSE=$(curl -sf "${OLLAMA_URL}/api/generate" -d "{\"model\": \"${MODEL}\", \"prompt\": \"${PROMPT}\", \"stream\": false}")
WARM_END=$(date +%s%N)
WARM_WALL=$(( (WARM_END - WARM_START) / 1000000 ))

WARM_LOAD=$(echo "${WARM_RESPONSE}" | jq -r '.load_duration // 0')
WARM_PROMPT_EVAL=$(echo "${WARM_RESPONSE}" | jq -r '.prompt_eval_duration // 0')
WARM_EVAL=$(echo "${WARM_RESPONSE}" | jq -r '.eval_duration // 0')
WARM_EVAL_COUNT=$(echo "${WARM_RESPONSE}" | jq -r '.eval_count // 0')
WARM_PROMPT_COUNT=$(echo "${WARM_RESPONSE}" | jq -r '.prompt_eval_count // 0')

if [ "${WARM_EVAL_COUNT}" -gt 0 ]; then
  WARM_TPS=$(awk "BEGIN { printf \"%.1f\", ${WARM_EVAL_COUNT} / (${WARM_EVAL} / 1000000000) }")
else
  WARM_TPS="N/A"
fi

printf "${BOLD}Warm Inference Results:${RESET}\n"
label "Wall clock:" "${WARM_WALL} ms"
label "Model load:" "$(ns_to_ms ${WARM_LOAD}) ms  (should be ~0)"
label "Prompt eval (prefill):" "$(ns_to_ms ${WARM_PROMPT_EVAL}) ms  (${WARM_PROMPT_COUNT} tokens)"
label "Generation (decode):" "$(ns_to_ms ${WARM_EVAL}) ms  (${WARM_EVAL_COUNT} tokens)"
label "Tokens/sec (decode):" "${WARM_TPS} t/s"

# --- Test 4: Flash attention verification ---
header "TEST 4 — FLASH ATTENTION CHECK"

block \
  "Verify that OLLAMA_FLASH_ATTENTION=1 is actually set in the running container's environment." \
  "Flash attention reduces memory usage for KV cache and can improve throughput. It's set in compose.yml but worth confirming it's reaching the process." \
  "OLLAMA_FLASH_ATTENTION=1 should appear in the output."

FA_CHECK=$(nerdctl exec ollama env 2>/dev/null | grep -i "OLLAMA_FLASH_ATTENTION" || true)
if [ -n "${FA_CHECK}" ]; then
  info "Flash attention: ${FA_CHECK}"
else
  warn "OLLAMA_FLASH_ATTENTION not found in container environment!"
  warn "Flash attention may not be enabled. Check compose.yml."
fi

# --- Test 5: GPU offload verification ---
header "TEST 5 — GPU OFFLOAD VERIFICATION"

block \
  "Check how many layers are offloaded to the GPU vs CPU." \
  "If the model doesn't fit entirely in VRAM, some layers run on CPU which is dramatically slower. With 14 GB usable VRAM, all four currently-pulled models should fit fully on GPU." \
  "For ${MODEL}, you should see size_vram ≈ size (meaning the full model is on GPU, no CPU spillover)."

GPU_INFO=$(curl -sf "${OLLAMA_URL}/api/ps")
GPU_MODEL_INFO=$(echo "${GPU_INFO}" | jq -r ".models[] | select(.name == \"${MODEL}\")")

if [ -n "${GPU_MODEL_INFO}" ]; then
  SIZE=$(echo "${GPU_MODEL_INFO}" | jq -r '.size')
  SIZE_VRAM=$(echo "${GPU_MODEL_INFO}" | jq -r '.size_vram')
  PCT=$(awk "BEGIN { printf \"%.1f\", (${SIZE_VRAM} / ${SIZE}) * 100 }")
  label "Total model size:" "$(awk "BEGIN { printf \"%.1f\", ${SIZE} / 1073741824 }") GB"
  label "VRAM allocated:" "$(awk "BEGIN { printf \"%.1f\", ${SIZE_VRAM} / 1073741824 }") GB"
  label "GPU offload:" "${PCT}%"
  if [ "$(awk "BEGIN { print (${PCT} > 99) }")" -eq 1 ]; then
    info "Full GPU offload — no CPU spillover."
  else
    warn "Partial offload! ${PCT}% on GPU, rest on CPU. Inference will be slower."
  fi
else
  warn "Model not currently loaded. Run a prompt first to check offload status."
fi

# --- Test 6: Open WebUI overhead (optional) ---
header "TEST 6 — OPEN WEBUI OVERHEAD (Optional)"

block \
  "Compare latency when routing through Open WebUI vs direct Ollama API. This measures the middleware overhead." \
  "Open WebUI adds Python processing, OTEL tracing export to Phoenix, and its own request handling. If direct Ollama is fast but Open WebUI feels slow, this layer is the bottleneck." \
  "Small overhead (100–500ms) is normal. Multiple seconds of added latency suggests a problem in the middleware or tracing."

warn "This test requires an Open WebUI API key."
info "To get one: Open WebUI → Settings → Account → API Keys"
echo ""

if [ -n "${OPENWEBUI_API_KEY:-}" ]; then
  info "OPENWEBUI_API_KEY is set — running test..."
  OW_START=$(date +%s%N)
  OW_RESPONSE=$(curl -sf "http://localhost:3000/api/chat/completions" \
    -H "Content-Type: application/json" \
    -H "Authorization: Bearer ${OPENWEBUI_API_KEY}" \
    -d "{\"model\": \"${MODEL}\", \"messages\": [{\"role\": \"user\", \"content\": \"${PROMPT}\"}], \"stream\": false}" 2>&1) || true
  OW_END=$(date +%s%N)
  OW_WALL=$(( (OW_END - OW_START) / 1000000 ))

  printf "${BOLD}Open WebUI Results:${RESET}\n"
  label "Wall clock:" "${OW_WALL} ms"
  label "Warm Ollama baseline:" "${WARM_WALL} ms"
  label "Overhead:" "$(( OW_WALL - WARM_WALL )) ms"
else
  info "Skipping — set OPENWEBUI_API_KEY to enable:"
  info "  export OPENWEBUI_API_KEY=sk-..."
  info "  ./ollama-latency-bench.sh ${MODEL}"
fi

# --- Summary ---
header "SUMMARY"

printf "${BOLD}%-30s %10s %10s${RESET}\n" "Metric" "Cold" "Warm"
printf "%-30s %10s %10s\n"   "──────────────────────────────" "──────────" "──────────"
printf "%-30s %9s ms %9s ms\n" "Wall clock" "${COLD_WALL}" "${WARM_WALL}"
printf "%-30s %9s ms %9s ms\n" "Model load" "$(ns_to_ms ${COLD_LOAD})" "$(ns_to_ms ${WARM_LOAD})"
printf "%-30s %9s ms %9s ms\n" "Prompt eval" "$(ns_to_ms ${COLD_PROMPT_EVAL})" "$(ns_to_ms ${WARM_PROMPT_EVAL})"
printf "%-30s %9s ms %9s ms\n" "Generation" "$(ns_to_ms ${COLD_EVAL})" "$(ns_to_ms ${WARM_EVAL})"
printf "%-30s %8s t/s %8s t/s\n" "Decode throughput" "${COLD_TPS}" "${WARM_TPS}"

echo ""
LOAD_SEC=$(ns_to_sec ${COLD_LOAD})
if [ "$(awk "BEGIN { print (${COLD_LOAD} > 3000000000) }")" -eq 1 ]; then
  warn "Cold start is ${LOAD_SEC}s. If this bothers you, increase keep_alive:"
  info "  Add OLLAMA_KEEP_ALIVE=30m to ollama's environment in compose.yml"
fi

if [ "${WARM_TPS}" != "N/A" ] && [ "$(awk "BEGIN { print (${WARM_TPS} < 20) }")" -eq 1 ]; then
  warn "Decode throughput is below 20 t/s. Possible causes:"
  info "  - Partial GPU offload (check Test 5)"
  info "  - Flash attention not enabled (check Test 4)"
  info "  - Model too large for available VRAM"
fi

echo ""
info "Done. Run with a different model: ./ollama-latency-bench.sh ${MODEL}"

# Todo(MMC): I have an observation of the test where I suspect it isn't really conducive to the workflow I want to execute. Also it only tests out one model. So my question is how can we test an actual workflow that is closer to what I want to do and which model should we test with? I think to go with what's in the system prompt, I want to use the local model for local prompting via cli.