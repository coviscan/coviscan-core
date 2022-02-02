#!/bin/bash

# use in MacOS to find absolute path of this script, since readlink -f is not available like in Linux
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

THIS_NAME="$(basename "${0}")"
THIS_PATH="$(realpath "${0}")"
THIS_DIR="$(dirname "${THIS_PATH}")"
DIR_ROOT="$(dirname "${THIS_DIR}")"

SPRING_DATASOURCE_USERNAME="postgres"
SPRING_DATASOURCE_PASSWORD="xxxx"

gcloud secrets create SPRING_DATASOURCE_USERNAME \
    --replication-policy="automatic"
echo -n "$SPRING_DATASOURCE_USERNAME" | \
    gcloud secrets versions add SPRING_DATASOURCE_USERNAME --data-file=-


gcloud secrets create SPRING_DATASOURCE_PASSWORD \
    --replication-policy="automatic"
echo -n "$SPRING_DATASOURCE_PASSWORD" | \
    gcloud secrets versions add SPRING_DATASOURCE_PASSWORD --data-file=-


gcloud secrets create DEV_DECORATOR_JKS \
    --replication-policy="automatic"
gcloud secrets versions add DEV_DECORATOR_JKS --data-file=$DIR_ROOT/certs/dev-decorator.jks
