# Network
data "aws_eip" "hacker_ip" {
  tags = {
    Name          = "hacker_ip"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_subnet" "access_subnet" {
  vpc_id     = "${aws_vpc.hacking_vpc.id}"
  cidr_block = "${local.access_cidr}"

  tags = {
    Name          = "access-subnet"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_route_table_association" "access_route_table_association" {
  subnet_id      = "${aws_subnet.access_subnet.id}"
  route_table_id = "${aws_route_table.hacking_route_table.id}"
}

resource "aws_security_group" "access_sg" {
  name        = "access_security_group"
  description = "Security rules for the access vm"
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
    Name          = "access-security-group"
    ResourceGroup = "${local.env}"
  }
}

# VM
resource "aws_instance" "access_vm" {
  ami           = "${data.aws_ami.centos.id}"
  instance_type = "${local.default_vm_size}"  # Kali wont run on t3s
  key_name      = "tom-hacker-keypair"

  subnet_id              = "${aws_subnet.access_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.access_sg.id}"]
  depends_on             = ["aws_internet_gateway.gw"]

  root_block_device = {
    volume_type           = "standard"
    delete_on_termination = true
  }

  tags = {
    Name          = "access-vm"
    ResourceGroup = "${local.env}"
  }
}

resource "aws_eip_association" "access_eip_assoc" {
  instance_id   = "${aws_instance.access_vm.id}"
  allocation_id = "${data.aws_eip.hacker_ip.id}"
}

# this provisioning cant be done in access_vm because it will try and run before the public ip has been attached
resource "null_resource" "access" {
  triggers = {
    access_instance = "${aws_instance.access_vm.id}"
  }

  connection {
    type        = "ssh"
    host        = "${data.aws_eip.hacker_ip.public_ip}"
    user        = "centos"
    private_key = "${file("tom-hacker-keypair.pem")}"
  }

  provisioner "remote-exec" {
    scripts = [
      "./scripts/update.sh",
      "./scripts/docker.sh",
    ]
  }
}
