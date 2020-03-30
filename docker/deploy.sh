#!/bin/bash

set -euo pipefail

tag_name=$1
echo "$DOCKER_PASSWORD" | docker login -u "$DOCKER_USERNAME" --password-stdin;
docker build --tag $REGISTRY_URI:$tag_name -f docker/Dockerfile .
docker push $REGISTRY_URI:$tag_name

if [ "$tag_name" == "master" ] && [ -n "$AUTODEPLOY_URL" ] && [ -n "$AUTODEPLOY_TOKEN" ]; then
    # Notifying webhook
    curl -s  \
      --output /dev/null \
      --write-out "%{http_code}" \
      -H "Content-Type: application/json" \
      -X POST \
      -d '{"push_data": {"tag": "'$AUTODEPLOY_TAG'" }}' \
      $AUTODEPLOY_URL
fi
