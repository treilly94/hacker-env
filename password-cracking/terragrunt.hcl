include {
  path = find_in_parent_folders()
}

locals {

}

terraform {
  source = "../modules/password-cracking"
}

inputs = {
}