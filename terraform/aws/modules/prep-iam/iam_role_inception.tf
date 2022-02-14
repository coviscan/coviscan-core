resource "aws_iam_role" "main" {
  name = "${var.resource_name_prefix}_iam_main"
  assume_role_policy = local.assume_role_policy
}