variable "aws_region" {
  type = string
  description = "AWS region"
}

variable "aws_backend_bucket" {
  type = string
  description = "Name of the AWS S3 terraform backend bucket"
}

variable "github_org" {
  type = string
  description = "Github organization name"
}

variable "github_repo" {
  type = string
  description = "Github repository name"
}

variable "resource_name_prefix" {
  type = string
  description = "Prefix of the resource names like roles, policies etc."
}