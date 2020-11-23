locals {
}

generate "provider" {
  path = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents = <<EOF
provider "digitalocean" {
  token = var.do_token
}
EOF
}