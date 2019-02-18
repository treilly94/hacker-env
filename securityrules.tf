resource "aws_security_group" "hacker_sg" {
  name        = "hacker_security_group"
  description = "Security rules for the hacker vms"
  vpc_id      = "${aws_vpc.hacking_vpc.id}"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "hacker-security-group"
  }
}