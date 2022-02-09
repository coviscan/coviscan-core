resource "aws_iam_role" "inception" {
  name = "${var.resource_name_prefix}_iam_manager"
  assume_role_policy = local.assume_role_policy
}

resource "aws_iam_policy" "inception" {
  name        = "${var.resource_name_prefix}_iam_manager"
  description = ""

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "iam:CreateRole",
          "iam:CreatePolicy",
          "iam:CreatePolicyVersion",
          "iam:PutRolePolicy",
          "iam:UpdateRole",
          "iam:UpdateRoleDescription",
          "iam:UpdateAssumeRolePolicy",
          "iam:ListRoles",
          "iam:ListPolicies",
          "iam:ListAttachedRolePolicies",
          "iam:GetPolicy",
          "iam:GetRole",
          "iam:GetRolePolicy",
          "iam:GetPolicyVersion",
          "iam:AttachRolePolicy",
          "iam:PassRole",
          "iam:DeleteRole",
          "iam:DeletePolicy",
          "iam:DeletePolicyVersion",
          "iam:DeleteRolePolicy",
          "iam:DetachRolePolicy",
        ],
        "Resource": [
          "arn:aws:iam::${local.account_id}:policy/${var.resource_name_prefix}*",
          "arn:aws:iam::${local.account_id}:role/${var.resource_name_prefix}*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "inception" {
  role       = aws_iam_role.inception.name
  policy_arn = aws_iam_policy.inception.arn
}