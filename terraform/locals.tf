# ------------------------------------------------------------------------------
# NODE DEFINITIONS
# ------------------------------------------------------------------------------
locals {
  k3s = {
    "k3s-master-1" = {
      os_code_name = "bookworm"
      octetIP      = "201"
      mac          = "52:54:00:00:01:c9"
      vcpu         = 2
      memoryMB     = 2048
      incGB        = 20
    }

    "k3s-worker-1" = {
      os_code_name = "bookworm"
      octetIP      = "202"
      mac          = "52:54:00:00:01:ca"
      vcpu         = 1
      memoryMB     = 1536
      incGB        = 20
    }

    "k3s-worker-2" = {
      os_code_name = "bookworm"
      octetIP      = "203"
      mac          = "52:54:00:00:01:cb"
      vcpu         = 1
      memoryMB     = 1536
      incGB        = 20
    }
  }
}