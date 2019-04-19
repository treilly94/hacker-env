sudo yum install -y yum-utils \
	device-mapper-persistent-data \
	lvm2

sudo yum-config-manager \
	--add-repo \
	https://download.docker.com/linux/centos/docker-ce.repo

sudo yum install -y docker-ce \
	docker-ce-cli \
	containerd.io

# Daemon config
sudo mkdir /etc/docker
export IP=$(hostname -I | awk '{ print $1}')
cat << EOF | sudo tee -a /etc/docker/daemon.json
{
	"hosts": [
		"unix:///var/run/docker.sock",
		"tcp://$IP:2375"
	]
}
EOF

sudo mkdir /etc/systemd/system/docker.service.d/
cat << EOF | sudo tee -a /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd
EOF
sudo systemctl daemon-reload

# Start
sudo systemctl start docker

# Run without sudo
sudo groupadd docker
sudo usermod -aG docker $USER

# Start on boot
sudo systemctl enable docker