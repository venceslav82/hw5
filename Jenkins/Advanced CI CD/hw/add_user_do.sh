#!/bin/bash

if [ $(id -u) -eq 0 ]; then
	USERNAME="jenkins"
	PASSWORD="Password1"
	egrep "^$USERNAME" /etc/passwd >/dev/null
	if [ $? -eq 0 ]; then
		echo "$USERNAME exists!"
		exit 1
	else
		useradd -m -p "$PASSWORD" "$USERNAME"
		[ $? -eq 0 ] && echo "User has been added!" || echo "Failed to add a user!"
	fi
else
	echo "Only root may add a user to the system."
	exit 2
fi 

echo "### Adding the $USERNAME user to the sudoers list..."
sudo sh -c "echo \"$USERNAME ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"

echo "### Adding the $USERNAME user to the docker group..."
sudo usermod -aG docker jenkins

echo "### Switch to $USERNAME user, chnage it's password, generate a public/private key pair and copy the SSH key to the jenkins host machine..."
sudo su - $USERNAME
sudo chpasswd <<<"$USERNAME:$PASSWORD"
echo | ssh-keygen -t rsa -m PEM -P ''
sshpass -p "$PASSWORD" ssh-copy-id jenkins@jenkins.m5.hw
