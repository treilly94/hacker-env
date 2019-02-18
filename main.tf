provider "aws" {
  region  = "eu-west-2"
  profile = "admin"
}

locals {
  vpc_cidr = "10.0.0.0/16"
  target_cidr = "${cidrsubnet(local.vpc_cidr,4,3)}" # 20
  hacker_cidr = "${cidrsubnet(local.vpc_cidr,4,4)}" # 20
}

data "aws_ami" "centos" {
  most_recent = true

  filter {
    name = "product-code"
    values = ["aw0evgkw8e5c1q413zgy5pjce"]
  }
}

resource "aws_vpc" "hacking_vpc" {
  cidr_block = "${local.vpc_cidr}"

  tags = {
    Name = "vpc-hacking"
  }
}
