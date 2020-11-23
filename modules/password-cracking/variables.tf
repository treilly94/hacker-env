variable "do_token" {}
variable "ssh_agent" {}
variable "ssh_key" {
    default = "Thinkpad"
}
variable "region" {
    default = "lon1"
}
variable "size" {
    default = "s-1vcpu-1gb"
}
variable "tags" {
    default = ["hacking"]
}
