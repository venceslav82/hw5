#!/bin/bash

echo "### Restarting docker..."
sudo systemctl restart docker

echo "### Creating a new bridge network..."
docker network create --driver bridge app-network

echo "### Installing Docker compose (standalone)..."
curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose && chmod +x /tmp/docker-compose && sudo cp /tmp/docker-compose /usr/local/bin/docker-compose

echo "### Checking docker compose (standalone) version..."
docker-compose version

echo "### Installing Docker compose (integrated)..."
mkdir -p ~/.docker/cli-plugins/
curl -SL https://github.com/docker/compose/releases/download/v2.2.3/docker-compose-linux-x86_64 -o ~/.docker/cli-plugins/docker-compose
chmod +x ~/.docker/cli-plugins/docker-compose

echo "### Checking docker compose (integrated) version..."
docker compose version

echo "### Enter into the project folder..."
cd bgapp
pwd

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
docker swarm init --advertise-addr 192.168.56.11

echo "Asking for the swarm cluster token..."
docker swarm join-token -q worker

FILE=docker-compose-swarm.yaml
if [ -f "docker-compose-swarm.yaml" ]; then
    echo "### Starting Swarm stack..."
    docker stack deploy -c <(head -n 1 docker-compose-swarm.yaml ; docker compose -f docker-compose-swarm.yaml config) bgapp
elif [ -f "docker-compose.yaml" ]; then
    echo "### Starting Swarm stack..."
    docker stack deploy -c <(head -n 1 docker-compose.yaml ; docker compose -f docker-compose.yaml config) bgapp
else 
    echo "There is no docker compose yaml file...."
fi


echo "### List available stacks:"
docker stack ls

echo "### List the services in the bgapp stack:"
docker stack services bgapp

echo "### Check information about the stack:"
docker stack ps bgapp
