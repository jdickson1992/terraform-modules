resource "aws_iam_openid_connect_provider" "new_provider" {
  count = var.enabled && var.create_oidc_provider ? 1 : 0

  client_id_list  = [var.github_organization, "sts.amazonaws.com"]
  tags            = var.github_integration_tags
  thumbprint_list = [data.tls_certificate.provider.certificates[0].sha1_fingerprint]
  url             = format("https://%s", var.oidc_provider_url)
}
