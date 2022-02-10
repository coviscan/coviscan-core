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

module "ecs-app" {
  source = "../../modules/ecs-app"
  resource_name_prefix = "${var.resource_name_prefix}"
  deployment = "${var.deployment}"
  service_name = "${var.service_name}"
  cluster = "${var.cluster}"
  container_name = "dcc-validation-decorator"
  container_port = "8080"
  task_definition = "${var.task_definition}"
  instance_security_group_id = ""
}