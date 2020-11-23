#!/bin/bash

create_user() {
    useradd -m -s /bin/bash $1
    echo "$1:$2" | chpasswd
}

configure_ssh() {
    sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    systemctl restart sshd.service
}

apt-get update -y

create_user jeremy ymerej
create_user dave budlight
create_user keith 7642

configure_ssh
