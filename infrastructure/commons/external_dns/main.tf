resource "helm_release" "external_dns" {
  name         = var.release_name
  repository   = "https://kubernetes-sigs.github.io/external-dns/"
  chart        = "external-dns"
  namespace    = var.external_dns_namespace
  version      = var.external_dns_version
  force_update = true

  values = [local.external_dns_values]

  depends_on = [
    kubernetes_secret_v1.external_dns_cloudflare
  ]

}
