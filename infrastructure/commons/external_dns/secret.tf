resource "kubernetes_secret_v1" "external_dns_cloudflare" {
  count = var.dns_provider_name == "cloudflare" ? 1 : 0
  metadata {
    name      = "external-dns-cloudflare"
    namespace = var.external_dns_namespace
  }
  type = "Opaque"
  data = {
    "api-token" = var.cloudflare_token
  }
}

