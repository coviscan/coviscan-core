terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }

  backend "s3" {
    bucket = "coviscan-terraform"
    key    = "main/terraform.tfstate"
    region = "eu-central-1"
    workspace_key_prefix = "aws"
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "${var.aws_region}"
}

module "vpc" {
  source             = "../../modules/vpc"
  name               = var.resource_name_prefix
  cidr               = var.cidr
  private_subnets    = var.private_subnets
  public_subnets     = var.public_subnets
  availability_zones = var.availability_zones
  environment        = var.environment
}

module "security_groups" {
  source         = "../../modules/security-groups"
  name           = var.resource_name_prefix
  vpc_id         = module.vpc.id
  environment    = var.environment
  container_port = var.container_port
}

module "alb" {
  source              = "../../modules/alb"
  name                = var.resource_name_prefix
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  alb_security_groups = [module.security_groups.alb]
  health_check_path   = var.health_check_path
}

module "lb" {
  source              = "../../modules/lb"
  name                = var.resource_name_prefix
  vpc_id              = module.vpc.id
  subnets             = module.vpc.public_subnets
  environment         = var.environment
  alb_tls_cert_arn    = var.tsl_certificate_arn
  health_check_path   = var.health_check_path
  aws_alb_id          = module.alb.aws_alb_id
}

module "ecs" {
  source                      = "../../modules/ecs"
  name                        = var.resource_name_prefix
  environment                 = var.environment
  region                      = var.aws_region
  subnets                     = module.vpc.private_subnets
  aws_alb_target_group_arn    = module.alb.aws_alb_target_group_arn
  ecs_service_security_groups = [module.security_groups.ecs_tasks]
  container_port              = var.container_port
  container_cpu               = var.container_cpu
  container_memory            = var.container_memory
  container_image             = var.container_image
  service_desired_count       = var.service_desired_count
  container_environment = [
    { name = "LOG_LEVEL",
    value = "DEBUG" },
    { name = "PORT",
    value = var.container_port },
    { name = "SPRING_PROFILES_ACTIVE",
    value = "cloud" }
  ]
}

module "api-gateway" {
  source              = "../../modules/api-gateway"
  name                = var.resource_name_prefix
  environment         = var.environment
  container_port      = var.container_port
  aws_lb_arn          = module.lb.aws_lb_arn
  aws_lb_dns_name     = module.lb.aws_lb_dns_name
  tsl_certificate_arn = var.tsl_certificate_arn
}