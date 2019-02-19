output "Ips" {
  value = "${aws_instance.hacker_vms.*.public_ip}"
}
