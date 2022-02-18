resource "aws_lb" "main" {
  name               = "${var.name}-alb-${var.environment}"
  internal           = true
  load_balancer_type = "network"
  subnets            = var.subnets.*.id

  enable_deletion_protection = false

  tags = {
    Name        = "${var.name}-nlb-${var.environment}"
    Environment = var.environment
  }
}


resource "aws_lb_target_group" "main" {
  name        = "${var.name}-nlb-tg-${var.environment}"
  target_type = "alb"
  port        = 80
  protocol    = "TCP"
  vpc_id      = var.vpc_id

  health_check {
    healthy_threshold   = "3"
    protocol            = "HTTP"
    path                = var.health_check_path
  }
}

# Create target group attachment
# More details: https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_TargetDescription.html
# https://docs.aws.amazon.com/elasticloadbalancing/latest/APIReference/API_RegisterTargets.html
resource "aws_lb_target_group_attachment" "tg_attachment" {
    target_group_arn = aws_lb_target_group.main.arn
    target_id        = var.aws_alb_target_group_arn
    port             = 80
}

output "aws_lb_target_group_arn" {
  value = aws_alb_target_group.main.arn
}

output "aws_lb_arn" {
  value = aws_lb.main.arn
}

output "aws_lb_dns_name" {
  value = aws_lb.main.dns_name
}
