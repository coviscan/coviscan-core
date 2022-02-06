terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "coviscan-terraform"
    key = "terraform.tfstate"
    role_arn = "arn:aws:iam::161247518108:role/GithubOIDC_AmazonS3FullAccess"
    region = "eu-central-1"
    workspace_key_prefix = "aws"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "eu-central-1"
}

module "ecr-repository" {
  source = "../../modules/ecr-repository"
}