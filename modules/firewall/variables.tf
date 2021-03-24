variable "firewall_tags" {
  description = "The tags of vms to add to the firewall"
  type        = list
}

variable "firewall_allowed_ips" {
  description = "A list of allowed ips"
  type        = list
}
