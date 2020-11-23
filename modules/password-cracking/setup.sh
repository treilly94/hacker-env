#!/bin/bash

update() {
    echo "Updating apt"
    apt-get update -y
}

create_user() {
    echo "Adding $1"
    useradd -m -s /bin/bash $1
    echo "$1:$2" | chpasswd
}

configure_ssh() {
    echo "Configuring ssh"
    sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    systemctl restart sshd.service
}

update

create_user jeremy ymerej
create_user dave budlight
create_user keith 7642

configure_ssh
