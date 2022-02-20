terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "coviscan-terraform"
    key    = "ecr/terraform.tfstate"
    region = "eu-central-1"
    workspace_key_prefix = "aws"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
}

module "ecr-repository-dcc" {
  source = "../../modules/ecr"
  aws_ecr_repository_name = "dcc-validation-decorator"
}

module "ecr-repository-lambda-authorizer" {
  source = "../../modules/ecr"
  aws_ecr_repository_name = "x509-authorizer"
}