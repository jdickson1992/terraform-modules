# data.tf
data "aws_partition" "current" {}

data "tls_certificate" "provider" {
  url = format("https://%s/.well-known/openid-configuration", var.oidc_provider_url)
}

