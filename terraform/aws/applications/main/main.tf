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

module "ecs-app" {
  source = "../../modules/ecs-app"
  resource_name_prefix = "${var.resource_name_prefix}"
  deployment = "${var.deployment}"
  service_name = "${var.cluster}"
}