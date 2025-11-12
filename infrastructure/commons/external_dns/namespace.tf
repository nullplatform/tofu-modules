resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = var.external_dns_namespace
    labels = {
      name = var.external_dns_namespace
    }
  }
}