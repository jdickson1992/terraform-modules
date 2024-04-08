# policy_attachment.tf
resource "aws_iam_role_policy_attachment" "custom" {
  count = var.enabled && length(var.github_iam_role_policy_arns) > 0 ? max(1, length(var.github_iam_role_policy_arns)) : 1

  role       = aws_iam_role.role[0].name
  policy_arn = length(var.github_iam_role_policy_arns) > 0 ? var.github_iam_role_policy_arns[count.index % length(var.github_iam_role_policy_arns)] : "arn:${data.aws_partition.current.partition}:iam::aws:policy/AdministratorAccess"
}
