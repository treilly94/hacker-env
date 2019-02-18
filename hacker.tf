resource "aws_subnet" "hacker_subnet" {
  vpc_id            = "${aws_vpc.hacking_vpc.id}"
  cidr_block        = "${local.hacker_cidr}"

  tags = {
    Name = "hacker-subnet"
  }
}

resource "aws_instance" "tom_vm" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "t2.micro"

  subnet_id = "${aws_subnet.hacker_subnet.id}"

  tags = {
    Name = "tom-vm"
  }
}