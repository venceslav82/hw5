#!/bin/bash

echo "### Checking validity of the docker configuration..."
docker compose config

echo "### Initiating the build of the image..."
docker compose build

echo "### Checking hte list of images..."
docker image ls

echo "### Starting the service/s with attached session, to the session of the running container.."
echo "## For detached mode use '-d'"
docker compose up -d

echo "### Listing docker compose objects.."
docker compose ps
