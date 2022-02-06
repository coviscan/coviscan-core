terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "coviscan-terraform"
    key    = "terraform.tfstate"
    region = "eu-central-1"
    workspace_key_prefix = "aws"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

module "prep-iam" {
  source = "../../modules/prep-iam"
}

module "ecr-repository" {
  source = "../../modules/ecr-repository"
}