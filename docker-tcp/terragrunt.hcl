include {
  path = find_in_parent_folders()
}

terraform {
  source = "../modules/vm"
}

inputs = {
  name = "docker-tcp"
  script = "${get_terragrunt_dir()}/scripts/setup.sh"
}

dependencies {
  paths = ["../firewall"]
}
