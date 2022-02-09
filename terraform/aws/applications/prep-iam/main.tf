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
  region = "${var.aws_region}"
}

module "prep-iam" {
  source = "../../modules/prep-iam"
  github_org = "${var.github_org}"
  github_repo = "${var.github_repo}"
  resource_name_prefix = "${var.resource_name_prefix}"
}