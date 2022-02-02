#!/bin/bash

DOCKER_REGISTRY="us-central1-docker.pkg.dev"
PROJECT="dentsads"
REPOSITORY="dgca-validation-decorator"

gcloud auth print-access-token \
  --impersonate-service-account 104049953268461113592 | docker login \
  -u oauth2accesstoken \
  --password-stdin https://us-central1-docker.pkg.dev

# push the image
docker tag dgca-validation-decorator $DOCKER_REGISTRY/$PROJECT/$REPOSITORY/dgca-validation-decorator
docker push $DOCKER_REGISTRY/$PROJECT/$REPOSITORY/dgca-validation-decorator:latest