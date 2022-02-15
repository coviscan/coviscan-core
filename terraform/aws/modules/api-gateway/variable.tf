variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "aws_lb_arn" {
  description = "ARN of the application load balancer"
}

variable "aws_lb_dns_name" {
  type = string
  description = "The DNS name of the internal NLB"
}

variable "container_port" {
  description = "The port where the Docker container is exposed"
}