#!/bin/bash

echo "* Add hosts ..."
echo "192.168.56.11 docker1.hw.ivo docker1" >> /etc/hosts
echo "192.168.56.12 docker2.hw.ivo docker2" >> /etc/hosts
echo "192.168.56.13 docker3.hw.ivo docker3" >> /etc/hosts

echo "* Install Additional Packages ..."
sudo dnf install -y jq tree git nano

#echo "### Disable the firewall"
#sudo systemctl disable --now firewalld
# OR
echo "### Open ports: Firewall - swarm!2377/tcp for cluster management communications, 7946/tcp and 7946/udp for communication among nodes and 4789/udp for overlay network traffic."
sudo systemctl start firewalld
firewall-cmd --add-port=2377/tcp --permanent
firewall-cmd --add-port=4789/udp --permanent
firewall-cmd --add-port=7946/tcp --permanent
firewall-cmd --add-port=7946/udp --permanent

echo "### Firewall - open port 8080 ..."
firewall-cmd --permanent --add-port=8080/tcp
firewall-cmd --permanent --add-service=http
firewall-cmd --permanent --add-service=https
firewall-cmd --reload

systemctl stop firewalld
systemctl disable --now firewalld
