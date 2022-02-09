# An execution role is the role which ECS uses to schedule containers on our
# behalf. I.e. ECS may need access to some params in parameter store to start tasks with the correct environment variables. The containers running in a
# task use a different role than the execution role.

resource "aws_iam_role" "execution" {
  name = "${var.resource_name_prefix}_${var.deployment}_${var.service_name}_execution"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_policy" "execution" {
  name = "${var.resource_name_prefix}_${var.deployment}_${var.service_name}_execution"

  policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [{
      "Effect": "Allow",
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetRepositoryPolicy",
        "ecr:DescribeRepositories",
        "ecr:ListImages",
        "ecr:DescribeImages",
        "ecr:BatchGetImage"
      ],
      "Resource": [
        "arn:aws:ecr:*:${local.account_id}:repository/*"
      ]
    }, {
      "Effect": "Allow",
      "Action": [
        "ecr:GetAuthorizationToken"
      ],
      "Resource": "*"
    }]
  })
}

resource "aws_iam_role_policy_attachment" "execution_execution" {
  role       = "${aws_iam_role.execution.name}"
  policy_arn = "${aws_iam_policy.execution.arn}"
}

/* ==================== */

# A task role is the role which the containers in an ECS task use to access AWS
# services/resources. I.e. An app can make an S3 api call using its task role.

resource "aws_iam_role" "task" {
  name = "${var.resource_name_prefix}_${var.deployment}_${var.service_name}_task"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
      {
        "Effect": "Allow",
        "Principal": {
          "Service": "ecs-tasks.amazonaws.com"
        },
        "Action": "sts:AssumeRole"
      }
    ]
  })
}