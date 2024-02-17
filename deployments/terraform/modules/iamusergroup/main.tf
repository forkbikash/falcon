resource "aws_iam_user_group_membership" "iam_user_group_membership" {
  user   = var.iam_user_group_membership_user
  groups = var.iam_user_group_membership_groups
}
