data "aws_caller_identity" "account" {}

locals {
  account_id = "${data.aws_caller_identity.account.account_id}"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRoleWithWebIdentity"
      Effect = "Allow"
      Principal = {
        Federated = "arn:aws:iam::${local.account_id}:oidc-provider/token.actions.githubusercontent.com"
      }
      Condition = {
        StringLike = {
          "token.actions.githubusercontent.com:aud" : [
            "sts.amazonaws.com"
          ],
          "token.actions.githubusercontent.com:sub" : "repo:${var.github_org}/${var.github_repo}:*"
        }
      }
    },
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "AWS": "arn:aws:iam::${local.account_id}:role/${var.resource_name_prefix}_iam_manager"
      },
      "Effect": "Allow",
      "Sid": ""
    }]
  })
}