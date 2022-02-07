terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "${var.aws_backend_bucket}"
    key    = "terraform.tfstate"
    region = "${var.aws_region}"
    workspace_key_prefix = "aws"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
}

module "ecr-repository" {
  source = "../../modules/ecr-repository"
  aws_ecr_repository_name = ""
}