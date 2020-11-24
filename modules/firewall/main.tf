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
  }

  outbound_rule {
    protocol              = "udp"
    port_range            = "1-65535"
  }

  outbound_rule {
    protocol              = "icmp"
  }
}