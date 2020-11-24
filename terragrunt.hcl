locals {
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
variable do_token {}
provider "digitalocean" {
  token = var.do_token
}
EOF
}
