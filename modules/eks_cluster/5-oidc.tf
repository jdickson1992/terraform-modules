############################################################################################################
#                                OPENID CONNECT PROVIDER (OIDC Provider)
############################################################################################################

# This step sets up the OIDC provider connector, used to grant access to the AWS API
data "tls_certificate" "certificate" {
  count = var.enable_irsa ? 1 : 0

  url = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

# Create the OpenID Connect provider after retrieving the EKS TLS certificate
resource "aws_iam_openid_connect_provider" "oidc_provider" {
  count = var.enable_irsa ? 1 : 0

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.certificate[0].certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer
}