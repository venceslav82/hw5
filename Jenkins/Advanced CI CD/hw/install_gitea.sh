#!/bin/bash

test -f /node/docker-compose.yml && DOCKER_COMPOSE_FILE=/node/docker-compose.yml || DOCKER_COMPOSE_FILE=/node/docker-compose.yaml

if [ test -f $DOCKER_COMPOSE_FILE ]; then
    echo "::::: '$DOCKER_COMPOSE_FILE' file found... Deploying Gitea..."
    cp $DOCKER_COMPOSE_FILE .
    docker compose up -d
    echo "Gitea deployed sucessfully on http://192.168.56.12:3000"
else 
    echo "There is no docker compose yaml file found at destination '$DOCKER_COMPOSE_FILE'...."
fi

