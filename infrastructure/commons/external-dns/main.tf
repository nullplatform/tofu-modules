resource "helm_release" "external_dns" {
  name             = "external-dns"
  repository       = "https://kubernetes-sigs.github.io/external-dns/"
  chart            = "external-dns"
  namespace        = var.externa_dns_namespace
  create_namespace = true
  version          = var.external_dns_version

  values     = [local.external_dns_values]
  depends_on = [kubernetes_secret_v1.external_dns_cloudflare]
}
