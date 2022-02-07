variable "aws_ecr_repository_name" {
  type = string
  description = "Name of the ECR repository to be created"
}

variable "aws_region" {
  type = string
  description = "AWS region"
}

variable "aws_backend_bucket" {
  type = string
  description = "Name of the AWS S3 terraform backend bucket"
}