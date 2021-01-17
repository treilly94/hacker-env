include {
  path = find_in_parent_folders()
}

terraform {
  source = "../modules/vm"
}

inputs = {
  name = "password-cracking"
  script = "${get_terragrunt_dir()}/scripts/setup.sh"
}

dependencies {
  paths = ["../firewall"]
}
