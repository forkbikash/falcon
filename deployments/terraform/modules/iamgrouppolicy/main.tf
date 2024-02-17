resource "aws_iam_group_policy_attachment" "predefined_policy_attach" {
  group      = var.policy_group
  policy_arn = var.policy_arn
}
