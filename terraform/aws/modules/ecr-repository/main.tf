resource "aws_ecr_repository" "dcc-validation-decorator" {
  name = "dcc-validation-decorator"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = false
  }
}