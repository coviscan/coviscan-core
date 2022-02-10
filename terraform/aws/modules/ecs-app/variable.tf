variable "cluster" {}
variable "container_name" {}
variable "container_port" {}
variable "deployment" {}
variable "domain" {}
variable "task_definition" {}
variable "instance_security_group_id" {}

variable "lb_subnets" {
  type = "list"
}

locals {
  identifier = "${var.deployment}-${var.cluster}"
}

variable "number_of_tasks" {
  default = 1
}

variable "deployment_min_healthy_percent" {
  default = 50
}

variable "deployment_max_percent" {
  default = 100
}

variable "health_check_path" {
  default = "/"
}

variable "health_check_protocol" {
  default = "HTTPS"
}

variable "health_check_interval" {
  default = 10
}

variable "health_check_timeout" {
  default = 10
}

variable "health_check_http_codes" {
  default = "200"
}