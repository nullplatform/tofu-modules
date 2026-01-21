resource "helm_release" "cert_manager" {
  name       = "cert-manager"
  repository = "https://charts.jetstack.io"
  chart      = "cert-manager"
  namespace  = var.cert_manager_namespace

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


  values = [
    yamlencode(local.cert_manager_values)
  ]
}


resource "helm_release" "cert_manager_config" {
  name       = "cert-manager-config"
  repository = "https://nullplatform.github.io/helm-charts"
  chart      = "nullplatform-cert-manager-config"
  version    = var.cert_manager_config_version
  namespace  = var.cert_manager_namespace

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

  values = [
    local.cert_manager_default_values,
    local.cert_manager_provider_values,
  ]

  depends_on = [helm_release.cert_manager]
}

#########webhook oci############
resource "helm_release" "cert_manager_webhook_oci" {
  count      = var.cloud_provider == "oci" ? 1 : 0
  name       = "cert-manager-webhook-oci"
  repository = "https://dn13.gitlab.io/cert-manager-webhook-oci"
  chart      = "cert-manager-webhook-oci/cert-manager-webhook-oci"
  version    = var.cert_manager_webhook_oci_version
  namespace  = var.cert_manager_webhook_oci_namespace

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


  depends_on = [helm_release.cert_manager]
}

