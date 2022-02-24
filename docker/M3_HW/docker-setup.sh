#!/bin/bash

echo "### Removing old Docker instance if there are any..."
removalResult=$(sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine)
echo $removalResult

echo "### Adding Docker repository..."
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "### Installing Docker..."
sudo dnf update -y && dnf install -y docker-ce docker-ce-cli containerd.io

echo "### Enable and Start Docker deamon and configuring it to start on boot..."
sudo systemctl enable docker
sudo systemctl start docker

echo "### Check Docker deamon status..."
sudo systemctl status docker
echo "### INFO:: Installed Docker Version: ..."
sudo docker version
echo "### INFO:: Installed Docker System Info: ..."
sudo docker system info
  
echo "### Adding sudo user '$USER && vagrant' to the Docker group, to be able to work with docker without the need to use always sudo..."
sudo usermod -aG docker $USER && usermod -aG docker vagrant
