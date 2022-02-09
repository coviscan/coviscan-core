variable "aws_ecr_repository_name" {
  type = string
  description = "Name of the ECR repository to be created"
}

variable "resource_name_prefix" {
  type = string
  description = "Prefix of the resource names like roles, policies etc."
}