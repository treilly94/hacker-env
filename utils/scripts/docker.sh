#!/bin/bash
sudo yum install -y yum-utils \
	device-mapper-persistent-data \
	lvm2

sudo yum-config-manager \
	--add-repo \
	https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce \
	docker-ce-cli \
	containerd.io

# Start
sudo systemctl start docker

# Run without sudo
sudo groupadd docker
sudo usermod -aG docker $USER

# Start on boot
sudo systemctl enable docker