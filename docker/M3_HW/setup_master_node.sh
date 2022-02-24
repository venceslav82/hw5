#!/bin/bash

echo "### Creating a new bridge network..."
docker network create --driver bridge app-network

echo "### Installing Docker compose..."
curl -L https://github.com/docker/compose/releases/download/1.29.2/docker-compose-`uname -s`-`uname -m` > /tmp/docker-compose && chmod +x /tmp/docker-compose && sudo cp /tmp/docker-compose /usr/local/bin/docker-compose

echo "### Checking docker compose version..."
docker-compose version

echo "### Enter into the project folder..."
cd bgapp

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
