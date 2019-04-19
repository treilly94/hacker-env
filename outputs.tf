output "target_ip" {
  value = "${aws_instance.target_vm.public_ip}"
}

output "hacker_ips" {
  value = "${aws_instance.hacker_vms.*.public_ip}"
}
