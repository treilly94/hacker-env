locals {
  internet = ["0.0.0.0/0", "::/0"]
}

resource "digitalocean_firewall" "self" {
  name = "hacking"
  tags = var.firewall_tags

  inbound_rule {
    protocol         = "tcp"
    port_range       = "1-65535"
    source_addresses = var.firewall_allowed_ips
  }

  inbound_rule {
    protocol         = "udp"
    port_range       = "1-65535"
    source_addresses = var.firewall_allowed_ips
  }

  inbound_rule {
    protocol         = "icmp"
    source_addresses = var.firewall_allowed_ips
  }

  outbound_rule {
    protocol              = "tcp"
    port_range            = "1-65535"
    destination_addresses = local.internet
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
    destination_addresses = local.internet
  }

  outbound_rule {
    protocol              = "icmp"
    destination_addresses = local.internet
  }
}