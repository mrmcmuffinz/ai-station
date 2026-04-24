# Prompt: QEMU Single-Node VM Setup for CKA Exam Prep

I am preparing for the CKA (Certified Kubernetes Administrator) exam and need to deploy Kubernetes from scratch as part of my study plan. I want to build this out in incremental steps:

1. Simple 1-node cluster
2. Simple 2-node cluster
3. Simple 3-node cluster

This prompt covers step 1 only: a single headless Ubuntu VM running on my Ubuntu 24.04 host via QEMU/KVM.

## VM Requirements

1. Headless Ubuntu OS (no GUI, cloud image is fine).
2. Networking that provides two forms of host-to-VM access:
   - SSH into the VM from the QEMU host for interactive administration.
   - Direct host-side access to all Kubernetes component APIs (API server on 6443, etcd on 2379/2380, kubelet on 10250, kube-controller-manager on 10257, kube-scheduler on 10259) via port forwarding, so that tools like `kubectl` and `curl` running on the QEMU host can reach the cluster without SSHing into the VM first.
3. The VM should be pre-configured with OS-level Kubernetes prerequisites (kernel modules, sysctl settings, swap disabled, prerequisite packages) but should NOT install containerd, kubeadm, kubelet, kubectl, or any Kubernetes component. I will configure Kubernetes completely on my own.

## QEMU Host Context

- Host OS: Ubuntu 24.04 LTS
- I have set up QEMU before on this host, but it has been several months since I last used it. The current state of the QEMU installation is unknown and may be broken or incomplete. The setup steps need to account for this by verifying each layer (CPU virtualization, kernel modules, packages, user permissions) and fixing anything that is missing.

## Deliverable

Provide a single markdown document with two parts:

1. **Part 1: QEMU/KVM Verification and Setup** covering bottom-up verification of the QEMU/KVM stack (CPU virtualization flags, KVM kernel modules, package installation, user group permissions, smoke test). Include the fix inline for each layer if it is broken or missing.

2. **Part 2: Single-Node VM Creation Script** providing a self-contained bash script that downloads an Ubuntu cloud image, generates cloud-init configuration for headless first-boot setup, builds a cloud-init ISO, creates a qcow2 disk backed by the cloud image, and generates start/stop helper scripts. Include usage instructions, SSH access details, verification steps to confirm the VM is ready for Kubernetes installation, and instructions for accessing Kubernetes components from the host side after installation.

## Formatting Constraints

- Output must be markdown syntax.
- No em dashes anywhere. Use commas, periods, or parentheses instead.
- Narrative paragraph flow in prose sections rather than stacked single-sentence declarations.
