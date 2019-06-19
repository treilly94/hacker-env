output "target_ip" {
  value = "${aws_instance.target_vm.public_ip}"
}
