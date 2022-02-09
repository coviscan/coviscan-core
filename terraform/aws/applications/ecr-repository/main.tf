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
    role_arn = "arn:aws:iam::161247518108:role/coviscan_s3_fullaccess"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
}

module "ecr-repository" {
  source = "../../modules/ecr-repository"
  aws_ecr_repository_name = "${var.aws_ecr_repository_name}"
}