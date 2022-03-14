#!/bin/bash

SHARED_FOLDER=/node
DOCKER_COMPOSE_FILE=docker-compose.yml
test -f $SHARED_FOLDER/$DOCKER_COMPOSE_FILE || DOCKER_COMPOSE_FILE=docker-compose.yaml

if [ -f $SHARED_FOLDER/$DOCKER_COMPOSE_FILE ]; then
    echo "::::: '$DOCKER_COMPOSE_FILE' file found... Deploying Gitea..."
    cp $SHARED_FOLDER/$DOCKER_COMPOSE_FILE . && sudo chown vagrant:vagrant $DOCKER_COMPOSE_FILE
    docker compose up -d

    HOSTNAME_IP=$(hostname -i | awk '{print $2}')
    [ -z "$HOSTNAME_IP" ] && HOSTNAME_IP=$(hostname -i | awk '{print $1}')
    echo "Gitea deployed sucessfully on http://$HOSTNAME_IP:3000"
else 
    echo "There is no docker compose yaml file found at destination '$SHARED_FOLDER/$DOCKER_COMPOSE_FILE'...."
fi

