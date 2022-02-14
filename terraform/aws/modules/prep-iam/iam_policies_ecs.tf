resource "aws_iam_policy" "ecs" {
  name        = "${var.resource_name_prefix}_ecs"
  description = ""

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Action": [
          "ecs:CreateCluster",
          "ecs:CreateService",
          "ecs:DescribeClusters",
          "ecs:DescribeServices",
          "ecs:DescribeTaskDefinition",
          "ecs:DeregisterTaskDefinition",
          "ecs:ListClusters",
          "ecs:ListServices",
          "ecs:ListTaskDefinitions",
          "ecs:RegisterTaskDefinition",
          "ecs:DeleteCluster",
          "ecs:DeleteService",
          "ecs:UpdateCluster",
          "ecs:UpdateService",
          "ecs:UpdateServicePrimaryTaskSet"
        ],
        "Resource": [
          "*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "ecs" {
  role       = aws_iam_role.main.name
  policy_arn = aws_iam_policy.ecs.arn
}