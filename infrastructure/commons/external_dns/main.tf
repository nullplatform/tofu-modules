resource "kubernetes_namespace_v1" "external_dns" {
  count = var.create_namespace ? 1 : 0
  metadata {
    name = var.external_dns_namespace
  }
}

resource "helm_release" "external_dns" {
  name       = "external-dns-${var.type}"
  repository = "https://kubernetes-sigs.github.io/external-dns/"
  chart      = "external-dns"
  namespace  = var.external_dns_namespace
  version    = var.external_dns_version

  create_namespace  = false
  disable_webhooks  = false
  force_update      = true
  wait              = true
  wait_for_jobs     = true
  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true
  replace           = true
  recreate_pods     = true
  reset_values      = true
  reuse_values      = false
  dependency_update = true
  max_history       = 10

  values = [yamlencode(local.external_dns_values)]

  depends_on = [
    kubernetes_secret_v1.external_dns_cloudflare,
    kubernetes_secret_v1.external_dns_oci_config,
    kubernetes_secret_v1.external_dns_azure_config,
  ]
}

