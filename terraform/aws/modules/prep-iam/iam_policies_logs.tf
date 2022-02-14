resource "aws_iam_policy" "logs" {
  name        = "${var.resource_name_prefix}_logs"
  description = ""

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "logs:DescribeLogStreams"
        ],
        "Resource": [
          "arn:aws:logs:*:${local.account_id}:*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "logs" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.logs.arn
}