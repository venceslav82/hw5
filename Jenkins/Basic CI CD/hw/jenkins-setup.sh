#!/bin/bash

echo "### Downloading the repository information..."
sudo wget https://pkg.jenkins.io/redhat/jenkins.repo -O /etc/yum.repos.d/jenkins.repo

echo "### Importing the repository’s key..."
sudo rpm --import https://pkg.jenkins.io/redhat/jenkins.io.key

echo "### Updating/Refreshing repository info and list all available versions:::..."
sudo dnf update #&& dnf list --showduplicates jenkins

echo "### Installing latest Jenkins version..."
sudo dnf install -y jenkins

echo "### Disabling the Jenkins repository after the installation..."
sudo dnf config-manager --disablerepo jenkins

echo "### Installed Java 11 (recommended) ..."
sudo dnf install -y java-11-openjdk
java -version

echo "### Starting the Jenkins service..."
sudo systemctl start jenkins

echo "### Checking Jenkins service status..."
systemctl status jenkins

echo "### Enabling the service to start automatically on boot..."
sudo systemctl enable jenkins
