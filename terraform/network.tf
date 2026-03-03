# ------------------------------------------------------------------------------
# NETWORK CONFIGURATION
# ------------------------------------------------------------------------------
resource "libvirt_network" "k3s_network" {
  name      = "k3s-network"
  autostart = true

  domain = {
    name = "k3s.local"
  }

  forward = {
    mode = "nat"
  }

  ips = [{
    address = "10.17.3.1"
    netmask = "255.255.255.0"
    dhcp = {
      # This generates a list of static leases
      hosts = [
        for name, config in local.k3s : {
          name = name
          ip   = "10.17.3.${config.octetIP}"
          # We manually set a MAC address based on the octet to keep it unique
          mac = format("52:54:00:00:00:%02x", config.octetIP)
        }
      ]
    }
  }]
}