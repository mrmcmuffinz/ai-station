It has been a productive session! You’ve successfully moved your AI stack from a "hanging" CPU-bound state to a fully hardware-accelerated, stable environment.

Here is the summary of the issues we encountered and the specific fixes applied.

---

## 1. The SearXNG "Hanging" Issue

**The Problem:**
Open WebUI would hang or time out when performing web searches. Logs showed `ERROR:searx.botdetection` and `X-Forwarded-For` header errors. SearXNG was flagging your internal network traffic as a bot attack.

**The Fix:**

* **Trusting the Network:** Modified `settings.yml` to include a `pass_ip` list. This told SearXNG to trust requests coming from your local home network (`192.168.2.0/24`) and the internal Docker/nerdctl network (`172.16.0.0/12`).
* **Disabling the Limiter:** Set `limiter: false` in the configuration to prevent the aggressive 2026 security layer from blocking the AI.
* **Cleaning the Logs:** Explicitly disabled the `ahmia` and `torch` engines since they require a Tor proxy, which removed the red error lines from your startup logs.

---

## 2. Linux Permission & Ownership Conflicts

**The Problem:**
SearXNG was reporting `WARNING: file is not owned by searxng:searxng`. Because the container runs as a specific user ID (`977`), it couldn't modify or sometimes even read the configuration files owned by `root` or your user.

**The Fix:**

* **Numeric UID Mapping:** Changed ownership on the host using the specific ID the container expects: `sudo chown -R 977:977 /mnt/data2/monitoring/searxng/`.
* **Directory Permissions:** Fixed the parent directory ownership to stop the "UNKNOWN:UNKNOWN" directory warnings.

---

## 3. GPU Acceleration (The "Blackwell" Fix)

**The Problem:**
Ollama was "visible" to the GPU but was not using it for inference (staying on the CPU). This was due to the brand-new **RTX 5060 Ti (Blackwell)** architecture being too new for the experimental `cuda_v13` runner in Ollama.

**The Fix:**

* **Forcing the Stable Runner:** Added `OLLAMA_LLM_LIBRARY=cuda_v12` to the environment variables. This forced Ollama to use the stable CUDA 12 path, which supports the 50-series cards via JIT compilation.
* **Environment Lockdown:** Added `CUDA_VISIBLE_DEVICES=0` and `OLLAMA_DEBUG=1` to ensure the container had a direct, clear path to the primary GPU.
* **Nerdctl Deploy Logic:** Removed the invalid `runtime: nvidia` flag (which caused a crash) and relied on the `deploy: resources` block, which is the native way `nerdctl` handles GPU injection.

---

### Final Status Check

* **SearXNG:** Running with a clean log; local traffic is trusted.
* **Ollama:** Running on **GPU** with **9.4GB** VRAM allocated for the model.
* **Performance:** Inference is now handled by the **RTX 5060 Ti**, providing significantly faster response times in Open WebUI.
