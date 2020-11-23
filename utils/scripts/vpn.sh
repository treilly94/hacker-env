#!/bin/bash
export OVPN_DATA=/opt/openvpn/etc/

# Make config directory
sudo mkdir $OVPN_DATA

# Extract config to directory
sudo tar -xzf ~/hacker_openvpn.tar.gz -C $OVPN_DATA 

# Start Server
sudo docker run -v $OVPN_DATA:/etc/openvpn --restart unless-stopped -d -p 1194:1194/udp --cap-add=NET_ADMIN kylemanna/openvpn