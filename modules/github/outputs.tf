output "oidc_provider_url" {
  description = "URL of the OIDC provider"
  value       = aws_iam_openid_connect_provider.new_provider[0].url
}

output "iam_role_name" {
  description = "Name of the IAM role"
  value       = aws_iam_role.role[0].name
}
