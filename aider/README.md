# Overview 

I would like to create a simple tic tac toe game in python using Aider as the cli for pair programming and a self hosted ai model. Below should be a set of instructions on how to achieve this. More so this is just an experiment for education purposes!

# To startup ollama 

```
nerdctl compose up -d
```

# Preload the model in vram and persist

```
curl http://127.0.0.1:11434/api/generate \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{"model": "qwen2.5-coder:14b", "prompt": "", "options": {"num_ctx": 65536}, "keep_alive": "3h"}'
```

# To check if the model is loaded

```
ollama ps
NAME                 ID              SIZE     PROCESSOR          CONTEXT    UNTIL
qwen2.5-coder:14b    9ec8897f747e    18 GB    18%/82% CPU/GPU    32768      3 hours from now
```

# To install aider

```
pyenv virtualenv 3.13.9 aider
pyenv activate aider
which python
python -m pip install aider-install
aider-install
```

# To run aider

```
export OLLAMA_API_BASE=http://127.0.0.1:11434
export OLLAMA_API_KEY=<api-key> # Mac/Linux
aider --model ollama/qwen2.5-coder:14b
```

# Go into ask mode and load prompt

```
/ask
/read-only aider/prompts/tictactoev2.md
```

At this point you need to actually work with the ai model to evaluate the prompt and complete the task.
