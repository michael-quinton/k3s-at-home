# K3s on Libvirt (Terraform)

This project automates the deployment of a 3-node **K3s Kubernetes cluster** on a local Linux host using **Libvirt (KVM/QEMU)** and **Terraform**. It features a dedicated NAT network, static IP assignments via DHCP, and a headless Debian 12 (Bookworm) base.

## Architecture

* **1x Master Node** (`k3s-master-1`): 2 vCPU, 2GB RAM (IP: `10.17.3.201`)
* **2x Worker Nodes** (`k3s-worker-1/2`): 1 vCPU, 1.5GB RAM (IPs: `10.17.3.202`, `10.17.3.203`)
* **Network**: `10.17.3.0/24` (NAT)
* **OS**: Debian 12 (Generic Cloud Image)

## Getting Started

### 1. Prerequisites
Ensure your host has `libvirt`, `qemu-kvm`, and `terraform` installed. Your user must be in the `libvirt` group.

### 2. Configuration
The project uses a `cloud_init.cfg` to handle:
* User creation with SSH keys.
* **Serial Console Redirection**: Essential for headless operation (fixes "blank screen" issues in `virsh console`).
* Pre-installed packages: `qemu-guest-agent`, `open-iscsi`, `nfs-common`.

### 3. Deployment
```bash
terraform init
terraform apply -auto-approve