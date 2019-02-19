provider "aws" {
  region  = "eu-west-2"
  profile = "admin"
}

locals {
  vpc_cidr    = "10.0.0.0/16"
  target_cidr = "${cidrsubnet(local.vpc_cidr,4,3)}" # 20
  hacker_cidr = "${cidrsubnet(local.vpc_cidr,4,4)}" # 20

  hackers = ["tom", "stuart"]

  default_vm_size = "t2.micro"
}

data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
}

resource "aws_vpc" "hacking_vpc" {
  cidr_block = "${local.vpc_cidr}"

  tags = {
    Name          = "hacking-vpc"
    ResourceGroup = "Hacking"
  }
}

# For internet access
resource "aws_internet_gateway" "gw" {
  vpc_id = "${aws_vpc.hacking_vpc.id}"

  tags = {
    Name          = "hacking-gateway"
    ResourceGroup = "Hacking"
  }
}

resource "aws_route_table" "hacking_route_table" {
  vpc_id = "${aws_vpc.hacking_vpc.id}"

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = "${aws_internet_gateway.gw.id}"
  }

  tags = {
    Name          = "hacking-route-table"
    ResourceGroup = "Hacking"
  }
}
