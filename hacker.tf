resource "aws_subnet" "hacker_subnet" {
  vpc_id                  = "${aws_vpc.hacking_vpc.id}"
  cidr_block              = "${local.hacker_cidr}"
  map_public_ip_on_launch = true

  tags = {
    Name = "hacker-subnet"
  }
}

resource "aws_instance" "tom_vm" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"
  key_name      = "tom-hacker-keypair"

  subnet_id       = "${aws_subnet.hacker_subnet.id}"
  security_groups = ["${aws_security_group.hacker_sg.id}"]

  tags = {
    Name = "tom-vm"
  }
}