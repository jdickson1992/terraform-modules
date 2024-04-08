resource "kubernetes_namespace" "external_dns" {
  count      = (var.create_namespace && var.namespace != "kube-system") ? 1 : 0

  metadata {
    name = var.namespace
  }
}