resource "helm_release" "external-dns" {
  chart            = "external-dns"
  name             = "external-dns"
  namespace        = var.namespace
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  version          = "1.11.0"
  wait             = true

  values = [
    templatefile("${path.module}/templates/external-dns.yaml", {
      external_dns_role_arn = aws_iam_role.external_dns_role.arn
      domain                = var.domain
      node_selector         = var.node_selector
    })
  ]

  depends_on = [aws_route53_zone.private_hosted_zone]
}

resource "helm_release" "external-dns" {
  chart            = "external-dns"
  name             = "external-dns"
  namespace        = var.namespace
  repository       = var.helm_repo
  version          = var.helm_chart_version

  set {
    name  = "aws.region"
    value = data.aws_region.current.name
  }

  set {
    name  = "rbac.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.create"
    value = "true"
  }

  set {
    name  = "serviceAccount.name"
    value = "external-dns"
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.external_dns_role.arn
  }
}
