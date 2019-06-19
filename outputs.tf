output "vpn_ip" {
  value = "${data.aws_eip.hacker_ip.public_ip}"
}

output "target_ip" {
  value = "${aws_instance.target_vm.public_ip}"
}
