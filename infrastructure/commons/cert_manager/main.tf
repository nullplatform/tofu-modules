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


resource "kubernetes_secret_v1" "azure_cert_manager_sp" {
  count = var.cloud_provider == "azure" && var.azure_client_secret != "" ? 1 : 0
  metadata {
    name      = "azure-cert-manager-sp"
    namespace = var.cert_manager_namespace
  }
  data = {
    "client-secret" = var.azure_client_secret
  }
  depends_on = [helm_release.cert_manager]
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

  depends_on = [helm_release.cert_manager, kubernetes_secret_v1.azure_cert_manager_sp]
}

#########webhook oci############
resource "helm_release" "cert_manager_webhook_oci" {
  count      = var.cloud_provider == "oci" ? 1 : 0
  name       = "cert-manager-webhook-oci"
  repository = "https://dn13.gitlab.io/cert-manager-webhook-oci"
  chart      = "cert-manager-webhook-oci"
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

