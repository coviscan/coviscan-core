data "aws_caller_identity" "current" {}

locals {
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:aud" : [
            "sts.amazonaws.com"
          ],
          "token.actions.githubusercontent.com:sub" : "repo:coviscan/coviscan-core:*"
        }
      }
    }]
  })
}

resource "aws_iam_openid_connect_provider" "token_actions_githubusercontent_com" {
  url = "https://token.actions.githubusercontent.com"
  client_id_list = [
    "sts.amazonaws.com",
  ]
  thumbprint_list = [
    "6938fd4d98bab03faadb97b34396831e3780aea1"
  ]
}

/* ==================== */

resource "aws_iam_role" "coviscan_ecr_createrepository" {
  name = "coviscan_ecr_createrepository"
  assume_role_policy = local.assume_role_policy
}

resource "aws_iam_policy" "coviscan_ecr_createrepository" {
  name        = "coviscan_ecr_createrepository"
  description = ""

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Sid": "VisualEditor0",
        "Effect": "Allow",
        "Action": [
          "ecr:CreateRepository",
          "ecr:DescribeRepositories",
          "ecr:ListTagsForResource",
          "ecr:DeleteRepository"
        ],
        "Resource": "arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "coviscan_ecr_createrepository" {
  role       = aws_iam_role.coviscan_ecr_createrepository.name
  policy_arn = aws_iam_policy.coviscan_ecr_createrepository.arn
}

resource "aws_iam_role_policy_attachment" "coviscan_ecr_createrepository2" {
  role       = aws_iam_role.coviscan_ecr_createrepository.name
  policy_arn = aws_iam_policy.coviscan_s3_fullaccess.arn
}

/* ==================== */

resource "aws_iam_role" "coviscan_ecr_pushpull" {
  name = "coviscan_ecr_pushpull"
  assume_role_policy = local.assume_role_policy
}

resource "aws_iam_policy" "coviscan_ecr_pushpull" {
  name        = "coviscan_ecr_pushpull"
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
        "Resource": "arn:aws:ecr:*:${data.aws_caller_identity.current.account_id}:repository/*"
      }
    ]
  })
}

resource "aws_iam_policy" "coviscan_ecr_login" {
  name        = "coviscan_ecr_login"
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

resource "aws_iam_role_policy_attachment" "coviscan_ecr_pushpull" {
  role       = aws_iam_role.coviscan_ecr_pushpull.name
  policy_arn = aws_iam_policy.coviscan_ecr_pushpull.arn
}

resource "aws_iam_role_policy_attachment" "coviscan_ecr_login" {
  role       = aws_iam_role.coviscan_ecr_pushpull.name
  policy_arn = aws_iam_policy.coviscan_ecr_login.arn
}

/* ==================== */

resource "aws_iam_role" "coviscan_s3_fullaccess" {
  name = "coviscan_s3_fullaccess"
  assume_role_policy = local.assume_role_policy
}

resource "aws_iam_policy" "coviscan_s3_fullaccess" {
  name        = "coviscan_s3_fullaccess"
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

resource "aws_iam_role_policy_attachment" "coviscan_s3_fullaccess" {
  role       = aws_iam_role.coviscan_s3_fullaccess.name
  policy_arn = aws_iam_policy.coviscan_s3_fullaccess.arn
}