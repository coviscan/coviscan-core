
resource "aws_iam_role" "s3_fullaccess" {
  name = "${var.resource_name_prefix}_s3_fullaccess"
  assume_role_policy = local.assume_role_policy
}

resource "aws_iam_policy" "s3_fullaccess" {
  name        = "${var.resource_name_prefix}_s3_fullaccess"
  description = ""

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "s3:*",
          "s3-object-lambda:*"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "s3_fullaccess" {
  role       = aws_iam_role.s3_fullaccess.name
  policy_arn = aws_iam_policy.s3_fullaccess.arn
}