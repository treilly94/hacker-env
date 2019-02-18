resource "aws_subnet" "target_subnet" {
  vpc_id            = "${aws_vpc.hacking_vpc.id}"
  cidr_block        = "${local.target_cidr}"

  tags = {
    Name = "target-subnet"
  }
}

resource "aws_instance" "target_vm" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"

  subnet_id = "${aws_subnet.target_subnet.id}"

  tags = {
    Name = "target-vm"
  }
}