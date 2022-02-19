resource "aws_iam_policy" "ecr" {
  name        = "${var.resource_name_prefix}_ecr"
  description = ""

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecr:CreateRepository",
          "ecr:DescribeRepositories",
          "ecr:ListTagsForResource",
          "ecr:DeleteRepository",
          "ecr:PutLifecyclePolicy",
          "ecr:GetLifecyclePolicy",
          "ecr:DeleteLifecyclePolicy"
        ],
        "Resource": "arn:aws:ecr:*:${local.account_id}:repository/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "ecr:CompleteLayerUpload",
          "ecr:UploadLayerPart",
          "ecr:InitiateLayerUpload",
          "ecr:BatchCheckLayerAvailability",
          "ecr:PutImage"
        ],
        "Resource": "arn:aws:ecr:*:${local.account_id}:repository/*"
      },
      {
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.ecr.arn
}