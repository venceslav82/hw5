#!/bin/bash

echo "### Removing old Docker instance if there are any..."
sudo dnf remove docker docker-client docker-client-latest docker-common docker-latest docker-latest-logrotate docker-logrotate docker-selinux docker-engine-selinux docker-engine || true

echo "### Adding Docker repository..."
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

echo "### Install the packages (Java, git, Docker)..."
sudo dnf update -y && dnf install -y java-11-openjdk git docker-ce docker-ce-cli containerd.io

echo "### Enable and Start Docker deamon and configuring it to start on boot..."
sudo systemctl enable --now docker
sudo systemctl start docker

echo "### Check Docker deamon status..."
sudo systemctl status docker
echo "### INFO:: Installed Docker Version: ..."
sudo docker version
echo "### INFO:: Installed Docker System Info: ..."
sudo docker system info

echo "### Adjust the group membership: Adding sudo user '$USER && vagrant' to the Docker group, to be able to work with docker without the need to use always sudo..."
sudo usermod -aG docker $USER && usermod -aG docker vagrant

sudo systemctl restart docker
echo "### Checking docker deamon status..."
while true ; do
    sleep 5
    if [ "$(systemctl is-active docker)" = "active" ]; then 
        echo "Docker deamon is up! Checking status..."
        systemctl status docker
        break
    fi
done

echo "### Installing Docker Compose..."
mkdir -p /home/vagrant/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o /home/vagrant/.docker/cli-plugins/docker-compose
sudo chmod +x /home/vagrant/.docker/cli-plugins/docker-compose
