#!/bin/bash

if [ "$(basename $PWD)" != "$REPO" ]; then 
    [ -d "$REPO" ] && cd $REPO || pwd
fi

HOSTNAME_IP=$(hostname -i | awk '{print $2}')
[ -z "$HOSTNAME_IP" ] && HOSTNAME_IP=$(hostname -i | awk '{print $1}') 

echo "### Try to join '$HOSTNAME_IP' as a worker to the swarm cluster $FIRST_NODE_IP..."
if [ -f "$CLUSTER_TOKEN_FILE" ]; then
    echo "### Joining the node as a worker the the swarm cluster..."
    CLUSTER_TOKEN=$(head -n 1 $CLUSTER_TOKEN_FILE)
    echo "Cluster token: $CLUSTER_TOKEN"
    docker swarm join --token $CLUSTER_TOKEN --advertise-addr $HOSTNAME_IP $FIRST_NODE_IP:$CLUSTER_PORT
else 
    echo "Not found cluster's token! $CLUSTER_TOKEN_FILE wasn't found..."
fi

