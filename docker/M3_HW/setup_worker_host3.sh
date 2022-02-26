#!/bin/bash

echo "### Try to join '192.168.56.13' as a worker to the swarm cluster 192.168.56.11..."
FILE=cluster_tocker.txt
if [ -f "$FILE" ]; then
    echo "### Joining the node as a worker the the swarm cluster..."
    TOKEN=$(head -n 1 $FILE)
    docker swarm join --token $TOKEN --advertise-addr 192.168.56.13 192.168.56.11:2377
else 
    echo "Not found cluster's token! $FILE wasn't found..."
fi

