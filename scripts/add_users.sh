sudo useradd vorderman
echo bitches | sudo passwd vorderman --stdin

sudo useradd savile
echo 7642 | sudo passwd savile --stdin

# Allow password auth
sudo sed -i -e 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
sudo systemctl restart sshd.service