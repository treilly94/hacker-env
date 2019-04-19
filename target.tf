resource "aws_subnet" "target_subnet" {
  vpc_id                  = "${aws_vpc.hacking_vpc.id}"
  cidr_block              = "${local.target_cidr}"
  map_public_ip_on_launch = true

  tags = {
    Name          = "target-subnet"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_route_table_association" "target_route_table_association" {
  subnet_id      = "${aws_subnet.target_subnet.id}"
  route_table_id = "${aws_route_table.hacking_route_table.id}"
}

resource "aws_security_group" "target_sg" {
  name        = "target_security_group"
  description = "Security rules for the target vms"
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
    Name          = "target-security-group"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_instance" "target_vm" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "${local.default_vm_size}"
  key_name      = "tom-hacker-keypair"

  subnet_id              = "${aws_subnet.target_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.target_sg.id}"]
  depends_on             = ["aws_internet_gateway.gw"]

  root_block_device = {
    volume_type           = "standard"
    delete_on_termination = true
  }

  tags = {
    Name          = "target-vm"
    ResourceGroup = "${local.env}"
  }

  provisioner "remote-exec" {
    connection {
      type        = "ssh"
      host        = "${self.public_ip}"
      user        = "centos"
      private_key = "${file("tom-hacker-keypair.pem")}"
    }

    scripts = [
      "./scripts/update.sh",
      "./scripts/add_users.sh",
    ]
  }
}
