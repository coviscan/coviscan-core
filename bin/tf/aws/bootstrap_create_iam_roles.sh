#!/bin/bash

# use in MacOS to find absolute path of this script, since readlink -f is not available like in Linux
realpath() {
    [[ $1 = /* ]] && echo "$1" || echo "$PWD/${1#./}"
}

THIS_NAME="$(basename "${0}")"
THIS_PATH="$(realpath "${0}")"
THIS_DIR="$(dirname "${THIS_PATH}")"
DIR_ROOT="$(dirname $(dirname $(dirname "${THIS_DIR}")))"

source ${DIR_ROOT}/bin/helper/helper.sh

##
## CHECK PREREQUISITES
##

if [ -z "$AWS_ACCESS_KEY" ]; then
    print_error "You need to set the AWS_ACCESS_KEY environment variable for the AWS access token"
fi

if [ -z "$AWS_SECRET_KEY" ]; then
    print_error "You need to set the AWS_SECRET_KEY environment variable for the AWS secret token"
fi

if ! which aws > /dev/null; then
   print_error "aws cli was not found. Please install it."
fi

if ! which terraform > /dev/null; then
   print_error "terraform cli was not found. Please install it."
fi

##
## CREATE IAM ROLES
##

print_status "Creating initial IAM roles needed to assume for all terraform projects"

pushd ${DIR_ROOT}/terraform/aws/applications/prep-iam

terraform init
terraform plan
terraform apply -auto-approve

popd