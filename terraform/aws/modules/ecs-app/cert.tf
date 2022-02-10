resource "aws_acm_certificate" "cert" {
  domain_name       = "api.coviscan.io"
  validation_method = "DNS"

  tags = {
    Environment = "dev"
  }

  lifecycle {
    create_before_destroy = true
  }
}