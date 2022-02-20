resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/AWSLambda_FullAccess"
}