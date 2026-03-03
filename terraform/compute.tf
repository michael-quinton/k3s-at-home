# ------------------------------------------------------------------------------
# VM IDENTITY & CLOUD-INIT
# ------------------------------------------------------------------------------
resource "libvirt_cloudinit_disk" "k3s_init_iso" {
  for_each = local.k3s
  name     = "${each.key}-iso"

  # user_data handles users, ssh keys, and packages
  user_data = templatefile("${path.module}/cloud_init.cfg", {
    hostname = each.key
    fqdn     = "${each.key}.k3s.local"
    username = var.user_username
    password = var.user_password
    sshkey   = var.ssh_public_key
  })

  # meta_data is REQUIRED by this schema version
  meta_data = jsonencode({
    "instance-id"    = each.key
    "local-hostname" = each.key
  })
}

resource "libvirt_volume" "k3s_init_volume" {
  for_each = local.k3s
  name     = "${each.key}-init.iso"
  pool     = libvirt_pool.k3s_pool.name

  target = {
    format = {
      type = "iso"
    }
  }

  create = {
    content = {
      url = libvirt_cloudinit_disk.k3s_init_iso[each.key].path
    }
  }
}

resource "libvirt_domain" "k3s_nodes" {
  for_each = local.k3s

  name   = each.key
  vcpu   = each.value.vcpu
  memory = each.value.memoryMB

  memory_unit = "MiB"
  type        = "kvm"
  autostart   = true
  running     = true

  os = {
    type         = "hvm"
    type_arch    = "x86_64"
    type_machine = "pc"
    boot_devices = [{ dev = "hd" }] # Ensures it looks for the Hard Drive
  }

  features = {
    acpi = true
    apic = {
      # This enables the Advanced Programmable Interrupt Controller
    }
  }

  devices = {
    disks = [
      {
        source = {
          volume = {
            pool   = libvirt_pool.k3s_pool.name
            volume = libvirt_volume.k3s_node_volume[each.key].name
          }
        }
        target = {
          dev = "vda"
          bus = "virtio"
        }

        driver = {
          type = "qcow2"
        }

        boot_order = "1" # <--- FORCE this to be the first boot device
      },
      {
        device = "cdrom"
        source = {
          volume = {
            pool   = libvirt_pool.k3s_pool.name
            volume = libvirt_volume.k3s_init_volume[each.key].name
          }
        }
        target = {
          dev = "sda"
          bus = "sata"
        }
        boot_order = "2" # <--- Cloud-init is second
      }
    ]

    interfaces = [
      {
        mac   = { address = format("52:54:00:00:00:%02x", each.value.octetIP) }
        model = { type = "virtio" }
        source = {
          network = {
            network = libvirt_network.k3s_network.name
          }
        }
      }
    ]

    # DELETED GRAPHICS BLOCK - This stops the "Element Vanished" error.

    # Standard serial console configuration for 'virsh console'
    consoles = [
      {
        type        = "pty"
        target_port = "0"
        target_type = "serial"
      }
    ]
  }
}