data "digitalocean_ssh_key" "key" {
  name = var.ssh_key
}

resource "digitalocean_droplet" "this" {
  image      = "ubuntu-18-04-x64"
  name       = "docker-tcp"
  region     = var.region
  size       = var.size
  monitoring = true
  tags       = var.tags
  ssh_keys   = [data.digitalocean_ssh_key.key.fingerprint]

  provisioner "remote-exec" {
    connection {
      type = "ssh"
      host = self.ipv4_address
      user = "root"
    }


    scripts = [
      "./scripts/setup.sh"
    ]
  }
}

resource "digitalocean_project" "this" {
  name = "docker-tcp"
  resources = [
    digitalocean_droplet.this.urn
  ]
}
