# AI-Station

This github repo is my personal playground code to setup a local AI environment for prompting for when claude goes on vacation. This isn't anything special and there are probably much better solutions out there however I'm taking this as an opportunity for learning experience. It ain't much but it's an honest living...

# System Specifications
CPU: AMD Ryzen 9 9900X 12-Core Processor (24 cores)
Total RAM: 62.44 GB
Available RAM: 54.57 GB
Backend: CUDA
GPU: NVIDIA GeForce RTX 5060 Ti (15.93 GB VRAM, CUDA)

# Software

```shell
$ containerd --version
containerd github.com/containerd/containerd/v2 v2.2.1 dea7da592f5d1d2b7755e3a161be07f43fad8f75

$ runc --version
runc version 1.4.0
commit: v1.4.0-0-g8bd78a99
spec: 1.3.0
go: go1.24.10
libseccomp: 2.5.6

$ nerdctl --version
nerdctl version 2.2.1

$ buildkitd --version
buildkitd github.com/moby/buildkit v0.27.1 5fbebf9d177edcc7af06c36c78728fdd357bf964

$ nvidia-smi --query-gpu=driver_version --format=csv,noheader
580.95.05

$ nvidia-ctk --version
NVIDIA Container Toolkit CLI version 1.18.2
commit: 9e88ed39710fd94c7e49fbb26d96492c45e574fb

$ uname -r
6.17.0-14-generic

$ uname -a
Linux box01 6.17.0-14-generic #14~24.04.1-Ubuntu SMP PREEMPT_DYNAMIC Thu Jan 15 15:52:10 UTC 2 x86_64 x86_64 x86_64 GNU/Linux
```
