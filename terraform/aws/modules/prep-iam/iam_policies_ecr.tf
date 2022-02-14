resource "aws_iam_policy" "ecr_createrepository" {
  name        = "${var.resource_name_prefix}_ecr_createrepository"
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
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_createrepository" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.ecr_createrepository.arn
}

/* ==================== */

resource "aws_iam_policy" "ecr_pushpull" {
  name        = "${var.resource_name_prefix}_ecr_pushpull"
  description = ""

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
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
      }
    ]
  })
}

resource "aws_iam_policy" "ecr_login" {
  name        = "${var.resource_name_prefix}_ecr_login"
  description = ""

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "ecr:GetAuthorizationToken"
        ],
        "Resource": "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecr_pushpull" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.ecr_pushpull.arn
}

resource "aws_iam_role_policy_attachment" "ecr_login" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.ecr_login.arn
}