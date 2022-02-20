variable "name" {
  description = "the name of your stack, e.g. \"demo\""
}

variable "environment" {
  description = "the name of your environment, e.g. \"prod\""
}

variable "aws_lb_arn" {
  description = "ARN of the NLB"
}

variable "aws_lb_dns_name" {
  type = string
  description = "The DNS name of the internal NLB"
}

variable "container_port" {
  description = "The port where the Docker container is exposed"
}

variable "tsl_certificate_arn" {
  description = "The ARN of the TLS certificate"
}

variable "s3_truststore_uri" {
  type = string
  description = "S3 mTLS truststore URI, e.g. s3://bucket-name/key-name "
}

variable "container_image" {
  description = "Docker image of lambda authorizer "
}
