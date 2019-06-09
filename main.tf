provider "aws" {
  region  = "eu-west-2"
  profile = "admin"
}

locals {
  env         = "Hacking"
  vpc_cidr    = "10.0.0.0/16"
  target_cidr = "${cidrsubnet(local.vpc_cidr,4,3)}" # 20
  hacker_cidr = "${cidrsubnet(local.vpc_cidr,4,4)}" # 20

  hackers = ["tom", "stuart", "gen", "kayleigh", "darrell"]

  default_vm_size = "t3.nano"
}

data "aws_ami" "centos" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
}

data "aws_ami" "kali" {
  most_recent = true
  owners      = ["aws-marketplace"]

  filter {
    name   = "product-code"
    values = ["89bab4k3h9x4rkojcm2tj8j4l"]
  }
}

resource "aws_vpc" "hacking_vpc" {
  cidr_block = "${local.vpc_cidr}"

  tags = {
    Name          = "${local.env}-vpc"
    ResourceGroup = "${local.env}"
  }
}

# For internet access
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.hacking_vpc.id}"

  tags = {
    Name          = "${local.env}-gateway"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_route_table" "hacking_route_table" {
  vpc_id = "${aws_vpc.hacking_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name          = "${local.env}-route-table"
    ResourceGroup = "${local.env}"
  }
}
