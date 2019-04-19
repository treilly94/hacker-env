resource "aws_subnet" "hacker_subnet" {
  vpc_id                  = "${aws_vpc.hacking_vpc.id}"
  cidr_block              = "${local.hacker_cidr}"
  map_public_ip_on_launch = true

  tags = {
    Name          = "${local.env}-subnet"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_route_table_association" "hacker_route_table_association" {
  subnet_id      = "${aws_subnet.hacker_subnet.id}"
  route_table_id = "${aws_route_table.hacking_route_table.id}"
}

resource "aws_security_group" "hacker_sg" {
  name        = "hacker_security_group"
  description = "Security rules for the hacker vms"
  vpc_id      = "${aws_vpc.hacking_vpc.id}"

  # SSH
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internet
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # Internal
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${local.vpc_cidr}"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["${local.vpc_cidr}"]
  }

  tags = {
    Name          = "${local.env}-security-group"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_instance" "hacker_vms" {
  count = "${length(local.hackers)}"

  ami           = "${data.aws_ami.centos.id}"
  instance_type = "${local.default_vm_size}"
  key_name      = "${local.hackers[count.index]}-hacker-keypair"

  subnet_id              = "${aws_subnet.hacker_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.hacker_sg.id}"]
  depends_on             = ["aws_internet_gateway.gw"]

  root_block_device = {
    volume_type           = "standard"
    delete_on_termination = true
  }

  tags = {
    Name          = "${local.hackers[count.index]}-vm"
    ResourceGroup = "${local.env}"
  }
}
