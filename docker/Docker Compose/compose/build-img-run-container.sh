#!/bin/bash

echo "### Buildint image from the Dockerfile..."
docker image build -t test .

echo "### Running container from the created image with port forwarding 8080 on the host to 80 on the guest..."
docker container run -d --name test -p 8080:80 test

echo "## Testing it with curl..."
curl http://localhost:8080






