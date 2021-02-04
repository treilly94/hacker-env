include {
  path = find_in_parent_folders()
}

terraform {
  source = "../modules/firewall"
}

inputs = {
  firewall_tags = [
    "hacking"
  ]
  firewall_allowed_ips = [
  ]
}

