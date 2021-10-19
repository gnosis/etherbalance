#!/bin/bash

set -veuo pipefail

tag_name=$1
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin;
docker build --tag $REGISTRY_URI:$tag_name -f docker/Dockerfile .
docker push $REGISTRY_URI:$tag_name
