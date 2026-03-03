# ------------------------------------------------------------------------------
# NODE DEFINITIONS
# ------------------------------------------------------------------------------
locals {
  k3s = {
    "k3s-master-1" = { os_code_name = "bookworm", octetIP = "201", vcpu = 2, memoryMB = 2048, incGB = 20 },
    "k3s-worker-1" = { os_code_name = "bookworm", octetIP = "202", vcpu = 1, memoryMB = 1536, incGB = 20 },
    "k3s-worker-2" = { os_code_name = "bookworm", octetIP = "203", vcpu = 1, memoryMB = 1536, incGB = 20 },
  }
}