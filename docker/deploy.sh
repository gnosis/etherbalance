#!/bin/bash

set -euo pipefail

image_name=$1
sudo apt-get update && sudo apt-get install -y python-pip && sudo pip install awscli
$(aws ecr get-login --no-include-email --region $AWS_REGION)
docker build --tag $REGISTRY_URI:$image_name -f docker/Dockerfile .
docker push $REGISTRY_URI:$image_name
