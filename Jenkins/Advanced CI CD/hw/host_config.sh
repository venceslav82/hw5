#!/bin/bash

echo "* Add hosts ..."
echo "192.168.99.11 jenkins.m5.hw jenkins" >> /etc/hosts
echo "192.168.99.12 docker.m5.hw docker" >> /etc/hosts

echo "* Install Additional Packages ..."
sudo dnf install -y jq tree git nano sshpass
sudo yum install -y lsof net-tools
