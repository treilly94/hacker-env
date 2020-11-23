provider "digitalocean" {
  token = var.do_token
}

locals {
  region = "lon1"
  size   = "s-1vcpu-1gb"
  tags   = ["hacking"]
}

data "digitalocean_ssh_key" "key" {
  name = "Thinkpad"
}

resource "digitalocean_droplet" "password_cracking" {
  image  = "ubuntu-18-04-x64"
  name       = "password-cracking"
  region     = local.region
  size       = local.size
  monitoring = true
  tags       = local.tags
  ssh_keys   = [data.digitalocean_ssh_key.key.fingerprint]

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = self.ipv4_address
      user        = "root"
      agent_identity = var.ssh_agent
    }

    scripts = [
      "./setup.sh"
    ]
  }
}

resource "digitalocean_project" "password_cracking" {
  name = "password-cracking"
  resources = [
    digitalocean_droplet.password_cracking.urn
  ]
}
