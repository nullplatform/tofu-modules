resource "kubernetes_namespace_v1" "external_dns" {
  metadata {
    name = var.external_dns_namespace
    labels = {
      name = var.external_dns_namespace
    }
  }
}