resource "aws_iam_policy" "application-autoscaling" {
  name        = "${var.resource_name_prefix}_application-autoscaling"
  description = ""

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": "application-autoscaling:*",
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "application-autoscaling" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.application-autoscaling.arn
}