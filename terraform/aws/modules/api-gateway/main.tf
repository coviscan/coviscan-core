resource "aws_api_gateway_rest_api" "main" {
  name = "${var.name}-gateway_rest_api-${var.environment}"

  disable_execute_api_endpoint = true
}

resource "aws_api_gateway_rest_api" "public" {
  name = "${var.name}-gateway_rest_api_public-${var.environment}"

  disable_execute_api_endpoint = true
}

resource "aws_api_gateway_vpc_link" "main" {
  name        = "${var.name}-gateway_vpc_link-${var.environment}"
  target_arns = [var.aws_lb_arn]
}

resource "aws_api_gateway_domain_name" "main" {
  domain_name              = "api.coviscan.io"
  regional_certificate_arn = var.tsl_certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  mutual_tls_authentication {
    truststore_uri = "${var.s3_truststore_uri}"
  }

  security_policy = "TLS_1_2"
}

resource "aws_api_gateway_domain_name" "public" {
  domain_name              = "api-public.coviscan.io"
  regional_certificate_arn = var.tsl_certificate_arn

  endpoint_configuration {
    types = ["REGIONAL"]
  }

  security_policy = "TLS_1_2"
}

resource "aws_api_gateway_resource" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  parent_id   = aws_api_gateway_rest_api.main.root_resource_id
  path_part   = "identity"
}

resource "aws_api_gateway_resource" "public" {
  rest_api_id = aws_api_gateway_rest_api.public.id
  parent_id   = aws_api_gateway_rest_api.public.root_resource_id
  path_part   = "status"
}

resource "aws_api_gateway_method" "main" {
  rest_api_id   = aws_api_gateway_rest_api.main.id
  resource_id   = aws_api_gateway_resource.main.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_method" "public" {
  rest_api_id   = aws_api_gateway_rest_api.public.id
  resource_id   = aws_api_gateway_resource.public.id
  http_method   = "GET"
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.main.http_method

  type                    = "HTTP"
  uri                     = "http://${var.aws_lb_dns_name}/identity"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.main.id
}

resource "aws_api_gateway_integration" "public" {
  rest_api_id = aws_api_gateway_rest_api.public.id
  resource_id = aws_api_gateway_resource.public.id
  http_method = aws_api_gateway_method.public.http_method

  type                    = "HTTP"
  uri                     = "http://${var.aws_lb_dns_name}/status"
  integration_http_method = "GET"
  passthrough_behavior    = "WHEN_NO_MATCH"
  content_handling        = "CONVERT_TO_TEXT"

  connection_type = "VPC_LINK"
  connection_id   = aws_api_gateway_vpc_link.main.id
}

resource "aws_api_gateway_method_response" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.main.http_method
  status_code = "200"
}

resource "aws_api_gateway_method_response" "public" {
  rest_api_id = aws_api_gateway_rest_api.public.id
  resource_id = aws_api_gateway_resource.public.id
  http_method = aws_api_gateway_method.public.http_method
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  resource_id = aws_api_gateway_resource.main.id
  http_method = aws_api_gateway_method.main.http_method
  status_code = aws_api_gateway_method_response.main.status_code
}

resource "aws_api_gateway_integration_response" "public" {
  rest_api_id = aws_api_gateway_rest_api.public.id
  resource_id = aws_api_gateway_resource.public.id
  http_method = aws_api_gateway_method.public.http_method
  status_code = aws_api_gateway_method_response.public.status_code
}

resource "aws_api_gateway_deployment" "main" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name = "${var.environment}-env"
  stage_description = "${md5(file("main.tf"))}"
  depends_on = [aws_api_gateway_integration.main]

  variables = {
    # just to trigger redeploy on resource changes
    resources = join(", ", [aws_api_gateway_resource.main.id])

    # note: redeployment might be required with other gateway changes.
    # when necessary run `terraform taint <this resource's address>`
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_deployment" "public" {
  rest_api_id = aws_api_gateway_rest_api.public.id
  stage_name = "${var.environment}-env"
  stage_description = "${md5(file("main.tf"))}"
  depends_on = [aws_api_gateway_integration.public]

  variables = {
    # just to trigger redeploy on resource changes
    resources = join(", ", [aws_api_gateway_resource.public.id])

    # note: redeployment might be required with other gateway changes.
    # when necessary run `terraform taint <this resource's address>`
  }

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_api_gateway_stage" "main" {
  deployment_id = aws_api_gateway_deployment.main.id
  rest_api_id   = aws_api_gateway_rest_api.main.id
  stage_name    = "${var.environment}-env"
}

resource "aws_api_gateway_stage" "public" {
  deployment_id = aws_api_gateway_deployment.public.id
  rest_api_id   = aws_api_gateway_rest_api.public.id
  stage_name    = "${var.environment}-env"
}

resource "aws_api_gateway_method_settings" "all" {
  rest_api_id = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  method_path = "*/*"

  settings {
    throttling_burst_limit = 50
    throttling_rate_limit = 10
  }
}

resource "aws_api_gateway_method_settings" "all_public" {
  rest_api_id = aws_api_gateway_rest_api.public.id
  stage_name  = aws_api_gateway_stage.public.stage_name
  method_path = "*/*"

  settings {
    throttling_burst_limit = 50
    throttling_rate_limit = 10
  }
}

resource "aws_api_gateway_base_path_mapping" "main" {
  api_id      = aws_api_gateway_rest_api.main.id
  stage_name  = aws_api_gateway_stage.main.stage_name
  domain_name = aws_api_gateway_domain_name.main.domain_name
}

resource "aws_api_gateway_base_path_mapping" "public" {
  api_id      = aws_api_gateway_rest_api.public.id
  stage_name  = aws_api_gateway_stage.public.stage_name
  domain_name = aws_api_gateway_domain_name.public.domain_name
}

resource "namecheap_domain_records" "main" {
  domain = "coviscan.io"
  mode = "MERGE"

  record {
    hostname = "api"
    type = "ALIAS"
    address = "11.22.33.44"
    ttl = 300
  }
}