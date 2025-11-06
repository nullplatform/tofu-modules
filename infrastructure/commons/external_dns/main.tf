resource "kubernetes_namespace" "external_dns" {
  metadata {
    name = var.external_dns_namespace
    labels = {
      name = var.external_dns_namespace
    }
  }
}

resource "kubernetes_secret_v1" "external_dns_cloudflare" {
  metadata {
    name      = "cloudflare-api-token"
    namespace = kubernetes_namespace_v1.external_dns.metadata[0].name
  }
  data = {
    api-token = var.cloudflare_api_token
  }
  type = "Opaque"
}

resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  namespace        = var.external_dns_namespace
  version          = var.external_dns_version

  values = [local.external_dns_values]

  depends_on = [
    kubernetes_secret_v1.external_dns_cloudflare
  ]

}
