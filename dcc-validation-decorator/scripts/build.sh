#!/bin/bash

# use in MacOS to find absolute path of this script, since readlink -f is not available like in Linux
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

THIS_NAME="$(basename "${0}")"
THIS_PATH="$(realpath "${0}")"
THIS_DIR="$(dirname "${THIS_PATH}")"
DIR_ROOT="$(dirname "${THIS_DIR}")"

mvn clean package -f $DIR_ROOT
docker build --no-cache -t dgca-validation-decorator $DIR_ROOT