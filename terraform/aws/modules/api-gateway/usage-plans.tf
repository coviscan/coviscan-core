resource "aws_api_gateway_usage_plan" "free" {
  name         = "${var.name}-up-free-${var.environment}"
  description  = "Free usage plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.main.id
    stage  = aws_api_gateway_stage.main.stage_name
  }

  quota_settings {
    limit  = 10
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = 5
    rate_limit  = 10
  }
}

resource "aws_api_gateway_usage_plan" "enterprise" {
  name         = "${var.name}-up-enterprise-${var.environment}"
  description  = "Enterprise usage plan"

  api_stages {
    api_id = aws_api_gateway_rest_api.main.id
    stage  = aws_api_gateway_stage.main.stage_name
  }

  quota_settings {
    limit  = 20
    period = "MONTH"
  }

  throttle_settings {
    burst_limit = 10
    rate_limit  = 20
  }
}

resource "aws_api_gateway_api_key" "free" {
  name = "free_key"
  enabled = false
  value = "free_key_r1hu21cfpuruk5kk1vip1scb8esh5r"
}

resource "aws_api_gateway_usage_plan_key" "free" {
  key_id        = aws_api_gateway_api_key.free.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.free.id
}


resource "aws_api_gateway_api_key" "enterprise" {
  name = "enterprise_key"
  enabled = false
  value = "enterprise_key_gvy52b7lmzd10led2l781bk8wdb8wj"
}

resource "aws_api_gateway_usage_plan_key" "enterprise" {
  key_id        = aws_api_gateway_api_key.enterprise.id
  key_type      = "API_KEY"
  usage_plan_id = aws_api_gateway_usage_plan.enterprise.id
}