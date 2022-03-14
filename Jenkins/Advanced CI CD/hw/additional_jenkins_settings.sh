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

echo "### Chnage jenkins user password..."
#sudo su - jenkins
sudo chpasswd <<<"jenkins:Password1"

#FIXME...
#echo "### Generate a public/private key pair, for the jenkins user..."
#echo | ssh-keygen -t rsa -m PEM -P '' -C jenkins@jenkins.m5.hw
#JENKINS_SSH_DIR="/var/lib/jenkins/.ssh"
#$[ -d $JENKINS_SSH_DIR ] || sudo mkdir $JENKINS_SSH_DIR && echo "Directory '$JENKINS_SSH_DIR' created."
#sudo cp /root/.ssh/id_rsa /var/lib/jenkins/.ssh/ && sudo cp /root/.ssh/id_rsa.pub /var/lib/jenkins/.ssh/
#sudo rm /root/.ssh/id_rsa && sudo rm /root/.ssh/id_rsa.pub
#sudo chown jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa && sudo chown jenkins:jenkins /var/lib/jenkins/.ssh/id_rsa.pub
#sudo chmod 400 /var/lib/jenkins/.ssh/id_rsa && chmod 400 id_rsa.pub
#echo "### Copy the SSH key to the jenkins machine..."
#sudo sshpass -p "Password1" ssh-copy-id -i /var/lib/jenkins/.ssh/id_rsa.pub jenkins@jenkins.m5.hw || true
#echo "### Copy the SSH key to the docker machine..."
#sudo sshpass -p "Password1" ssh-copy-id -i /var/lib/jenkins/.ssh/id_rsa.pub jenkins@docker.m5.hw || true

HOSTNAME_IP=$(hostname -i | awk '{print $2}')
    [ -z "$HOSTNAME_IP" ] && HOSTNAME_IP=$(hostname -i | awk '{print $1}')
echo "### Download Jenkins CLI .jar..."
wget http://$HOSTNAME_IP:8080/jnlpJars/jenkins-cli.jar || true






