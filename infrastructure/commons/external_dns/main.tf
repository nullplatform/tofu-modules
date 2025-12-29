resource "helm_release" "external_dns" {
  name         = "external-dns"
  repository   = "https://kubernetes-sigs.github.io/external-dns/"
  chart        = "external-dns"
  namespace    = var.external_dns_namespace
  version      = var.external_dns_version

  create_namespace  = true
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
    kubernetes_secret_v1.external_dns_cloudflare
  ]
}
