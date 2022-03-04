#!/bin/bash

echo "### Checking created jenkins user..."
cat /etc/passwd | grep jenkins

echo "### Adding sudo user 'jenkins' to the Docker group, to be able to work with docker without the need to use always sudo..."
sudo usermod -aG jenkins && usermod -aG jenkins

echo "### Change jenkin's shell from '/bin/false' to '/bin/bash'"
JENKINS_USER=$(cat /etc/passwd | grep jenkins)
[[ "$JENKINS_USER" == *bin/false ]] && sudo usermod -s /bin/bash jenkins

echo "### Adding the jenkins user to the sudoers list..."
sudo sh -c "echo \"jenkins ALL=(ALL) NOPASSWD: ALL\" >> /etc/sudoers"



#TODO...
#echo "### Entering into bin/bash as jenkins..."
#sudo su -s /bin/bash jenkins

#echo "### Generating an SSH key..."
#echo | ssh-keygen -t rsa -m PEM -P ''

#echo "Copy the key to localhost..."
#sshpass -p "Password1" ssh-copy-id jenkins@localhost
#TODO ..... page 5



echo "### Disabling Jenkins security to prevent unlocking..."
sudo sed -i 's/<useSecurity>true<\/useSecurity>/<useSecurity>false<\/useSecurity>/g' /var/lib/jenkins/config.xml
sudo ex +g/useSecurity/d +g/authorizationStrategy/d -scwq /var/lib/jenkins/config.xml

echo "### Restarting jenkins service..."
sudo systemctl restart jenkins

echo "### Checking jenkins status..."
while true ; do
    sleep 5
    if [ "$(systemctl is-active jenkins)" = "active" ]; then 
        echo "Jenkins service is up! Checking jenkins status..."
        systemctl status jenkins
        break
    fi
done
