resource "aws_iam_role_policy_attachment" "elb_full" {
  role       = aws_iam_role.main.name
  policy_arn = "arn:aws:iam::aws:policy/ElasticLoadBalancingFullAccess"
}