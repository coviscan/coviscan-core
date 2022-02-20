resource "aws_api_gateway_authorizer" "main" {
  name                   = "${var.name}-authorizer-${var.environment}"
  rest_api_id            = aws_api_gateway_rest_api.main.id
  authorizer_uri         = aws_lambda_function.authorizer.invoke_arn
  authorizer_credentials = aws_iam_role.invocation_role.arn
}

resource "aws_iam_role" "invocation_role" {
  name = "${var.name}-auth-invocation-${var.environment}"
  path = "/"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "apigateway.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_iam_role_policy" "invocation_policy" {
  name = "default"
  role = aws_iam_role.invocation_role.id

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "lambda:InvokeFunction",
        "Effect": "Allow",
        "Resource": "${aws_lambda_function.authorizer.arn}"
      }
    ]
  })
}

resource "aws_iam_role" "lambda" {
  name = "${var.name}-lambda-auth-${var.environment}"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": "sts:AssumeRole",
        "Principal": {
          "Service": "lambda.amazonaws.com"
        },
        "Effect": "Allow",
        "Sid": ""
      }
    ]
  })
}

resource "aws_lambda_function" "authorizer" {
  function_name = "${var.name}-api-gateway-authorizer-${var.environment}"
  role          = aws_iam_role.lambda.arn
  handler       = "index.handler"
  image_uri     = "${var.container_image}:latest"
}