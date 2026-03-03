resource "libvirt_pool" "k3s_pool" {
  name = "k3s-pool"
  type = "dir"

  target = {
    path = "/var/lib/libvirt/k3s-pool"
    permissions = {
      mode = "0755"
    }
  }
}

resource "libvirt_volume" "k3s_base_volume" {
  name = "debian-12-base.qcow2"
  pool = libvirt_pool.k3s_pool.name

  target = {
    format = {
      type = "qcow2"
    }
  }

  create = {
    content = {
      url = "https://cloud.debian.org/images/cloud/bookworm/latest/debian-12-generic-amd64.qcow2"
    }
  }
  # capacity is automatically computed from Content-Length header
}

resource "libvirt_volume" "k3s_node_volume" {
  for_each = local.k3s
  name     = "${each.key}-disk.qcow2"
  pool     = libvirt_pool.k3s_pool.name
  capacity = each.value.incGB * 1073741824

  target = {
    format = { type = "qcow2" }
  }

  backing_store = {
    path   = libvirt_volume.k3s_base_volume.path
    format = { type = "qcow2" }
  }
}
