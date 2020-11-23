data "digitalocean_ssh_key" "key" {
  name = var.ssh_key
}

resource "digitalocean_droplet" "password_cracking" {
  image  = "ubuntu-18-04-x64"
  name       = "password-cracking"
  region     = var.region
  size       = var.size
  monitoring = true
  tags       = var.tags
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
