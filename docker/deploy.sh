#!/bin/bash

set -xeuo pipefail

echo deploy_0
tag_name=$1
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin;
echo deploy_1
docker build --tag $REGISTRY_URI:$tag_name -f docker/Dockerfile .
echo deploy_2
docker push $REGISTRY_URI:$tag_name
echo deploy_3

if [ "$tag_name" == "master" ] && [ -n "$AUTODEPLOY_URL" ]; then
    # Notifying webhook
    curl -s  \
      --output /dev/null \
      --write-out "%{http_code}" \
      -H "Content-Type: application/json" \
      -X POST \
      -d '{"push_data": {"tag": "'$tag_name'" }}' \
      $AUTODEPLOY_URL
fi
echo deploy_4
