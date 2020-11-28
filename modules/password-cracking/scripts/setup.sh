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

configure_webserver() {
    echo "Configuring webserver"
    apt-get install -y apache2

    cat > /etc/apache2/sites-enabled/000-default.conf <<EOL
<VirtualHost *:80>
        ServerAdmin webmaster@localhost
        DocumentRoot /var/www/html

        ErrorLog \${APACHE_LOG_DIR}/error.log
        CustomLog \${APACHE_LOG_DIR}/access.log combined

        <Directory /var/www/html>
                AuthType Basic
                AuthName "Secure area - Authentication required"
                AuthUserFile /etc/apache2/.htpasswd
                Require valid-user
                Redirect permanent / https://media.tenor.com/videos/063c61b71e836431f5b15e5fcc577dbe/mp4
        </Directory>
</VirtualHost>
EOL

    echo "bob:\$apr1\$ALozgELl\$01od4iGN5mkZKBanHajAB." > /etc/apache2/.htpasswd

    systemctl restart apache2
}

update

create_user jeremy ymerej
create_user dave budlight
create_user keith 7642

configure_ssh

configure_webserver
