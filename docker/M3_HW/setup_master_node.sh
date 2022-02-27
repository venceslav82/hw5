#!/bin/bash

echo "### Restarting docker..."
sudo systemctl restart docker
while true ; do
    sleep 5
    if [ "$(systemctl is-active docker)" = "active" ]; then 
        echo "The docker deamon is Active!";
        break
    fi
done

echo "### Creating a new bridge network..."
docker network create --driver bridge app-network

#echo "### Installing Docker compose (standalone)..."
#curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose && chmod +x /tmp/docker-compose && sudo cp /tmp/docker-compose /usr/local/bin/docker-compose
#echo "### Checking docker compose (standalone) version..."
#docker-compose version

echo "### Installing Docker compose (integrated)..."
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

echo "### Checking docker compose (integrated) version..."
docker compose version

echo "### Try Enter into the project folder '$REPO'..."
if [ "$(basename $PWD)" != "$REPO" ]; then 
    [ -d "$REPO" ] && cd $REPO || pwd
fi

#echo "### Docker Hub login.."
#cat ~/my_password.txt | docker login --username foo --password-stdin
#docker login --username=$DOCKER_USER --password=$DOCKER_PASS $DOCKER_HOST

#echo "### Building WEB image..."
#docker image build -t ivelin1936/bgapp-hw-web -f Dockerfile.web .
#echo "### Building DB image..."
#docker image build -t ivelin1936/bgapp-hw-db -f Dockerfile.db .

#echo "### Pushing images into the Docker Hub..."
#docker image push ivelin1936/bgapp-hw-web
#docker image push ivelin1936/bgapp-hw-db

echo "Initialize it as the first node of the cluster"
HOSTNAME_IP=$(hostname -i | awk '{print $2}')
[ -z "$HOSTNAME_IP" ] && HOSTNAME_IP=$(hostname -i | awk '{print $1}') 
docker swarm init --advertise-addr $HOSTNAME_IP

echo "Asking for the swarm cluster token..."
docker swarm join-token -q worker

if [ -f "$COMPOSE_SWARM_YAML" ]; then
    echo "### Starting Swarm stack..."
    docker stack deploy -c <(head -n 1 $COMPOSE_SWARM_YAML ; docker compose -f $COMPOSE_SWARM_YAML config) $SERVICE_NAME
elif [ -f "$COMPOSE_YAML" ]; then
    echo "### Starting Swarm stack..."
    docker stack deploy -c <(head -n 1 $COMPOSE_YAML ; docker compose -f $COMPOSE_YAML config) $SERVICE_NAME
else 
    echo "There is no docker compose yaml file...."
fi


echo "### List available stacks:"
docker stack ls

echo "### List the services in the $SERVICE_NAME stack:"
docker stack services $SERVICE_NAME

echo "### Check information about the stack:"
docker stack ps $SERVICE_NAME

echo "### Saving the cluster's token into the 'clueter_tocker.txt' file..."
echo $(docker swarm join-token -q worker) > $CLUSTER_TOKEN_FILE
#echo "### Saving the cluster's token into the docker config.."
#docker config create cluster_token clueter_tocker.txt

echo "### Pushing created cluster_token.txt file to github '$SOURCE/$USERNAME/$REPO.git':::"
sudo git config --global user.email "$USERNAME"
sudo git config --global user.email "$EMAIL"
git add .
git commit -m 'Add/Update swarm cluster token...'
sudo git push https://$TOKEN@$SOURCE/$USERNAME/$REPO.git

