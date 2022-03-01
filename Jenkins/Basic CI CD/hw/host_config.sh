#!/bin/bash

echo "* Add hosts ..."
echo "192.168.56.11 jenkins.do1.lab jenkins" >> /etc/hosts

echo "* Install Additional Packages ..."
sudo dnf install -y jq tree git nano

#sudo systemctl stop firewalld
#sudo systemctl disable --now firewalld
# OR

#firewalld is pre-installed in centos 7 so....
INSTALLED_FIREWALLD=$(rpm -qa firewalld)
[ -z "$INSTALLED_FIREWALLD" ] && echo "### Installing firewalld..." && sudo yum install -y firewalld

FIREWALLD_LOAD_STATUS=$(echo $(systemctl status firewalld | grep "Loaded") | awk  '{print $2}')
[ "masked" = $FIREWALLD_LOAD_STATUS ] && sudo systemctl unmask --now firewalld

FIREWALLD_ACTIVE_STATUS=$(systemctl is-active firewalld)
if [ "inactive" = "$FIREWALLD_ACTIVE_STATUS" ]; then
    echo "Starting and enabling the firewalld...";
    sudo systemctl start firewalld
    sudo systemctl restart firewalld
    sudo systemctl enable firewalld
fi

echo "### Firewall - open tcp port 80, 8000, 8080 ..."
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=8000/tcp
sudo firewall-cmd --permanent --add-port=8080/tcp
sudo firewall-cmd --permanent --add-service=http
sudo firewall-cmd --permanent --add-service=https
sudo firewall-cmd --reload

echo "### Check firewall and accessible ports:::"
sudo firewall-cmd --list-all
