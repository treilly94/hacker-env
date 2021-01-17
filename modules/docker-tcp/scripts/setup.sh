#!/bin/bash

echo "Install Docker"
apt-get update -y
apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg-agent \
    software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
    $(lsb_release -cs) \
    stable"
apt-get update -y
apt-get install -y docker-ce docker-ce-cli containerd.io

echo "Configure Daemon"
mkdir /etc/docker
IP=$(hostname -I | awk '{ print $1}')
export IP
cat > /etc/docker/daemon.json <<EOL
{
	"hosts": [
		"unix:///var/run/docker.sock",
		"tcp://$IP:2375"
	]
}
EOL

echo "Configure Service"
mkdir /etc/systemd/system/docker.service.d/
cat > /etc/systemd/system/docker.service.d/override.conf <<EOL
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOL

systemctl daemon-reload
systemctl enable docker
systemctl restart docker
