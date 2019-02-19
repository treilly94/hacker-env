resource "aws_subnet" "hacker_subnet" {
  vpc_id                  = "${aws_vpc.hacking_vpc.id}"
  cidr_block              = "${local.hacker_cidr}"
  map_public_ip_on_launch = true

  tags = {
    Name          = "hacker-subnet"
    ResourceGroup = "Hacking"
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

  tags = {
    Name          = "hacker-security-group"
    ResourceGroup = "Hacking"
  }
}

resource "aws_instance" "hacker_vms" {
  count = "${length(local.hackers)}"

  ami           = "${data.aws_ami.centos.id}"
  instance_type = "${local.default_vm_size}"
  key_name      = "tom-hacker-keypair"

  subnet_id       = "${aws_subnet.hacker_subnet.id}"
  security_groups = ["${aws_security_group.hacker_sg.id}"]
  depends_on      = ["aws_internet_gateway.gw"]

  tags = {
    Name          = "${local.hackers[count.index]}-vm"
    ResourceGroup = "Hacking"
  }
}
