resource "aws_iam_policy" "iam" {
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
          "iam:ListRolePolicies",
          "iam:ListAttachedRolePolicies",
          "iam:ListInstanceProfilesForRole",
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
      },
      {
        "Effect": "Allow",
        "Action": [
          "iam:CreateServiceLinkedRole"    
        ],
        "Resource": [
          "arn:aws:iam::${local.account_id}:role/aws-service-role/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "iam" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.iam.arn
}