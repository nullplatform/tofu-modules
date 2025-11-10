resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = var.cert_manager_namespace
  create_namespace = true
  version          = var.cert_manager_version

  set = [{
    name  = "crds.enabled"
    value = "true"
    }
  ]
}


resource "helm_release" "cert_manager_config" {
  name             = "cert-manager-config"
  repository       = "https://nullplatform.github.io/helm-charts"
  chart            = "nullplatform-cert-manager-config"
  create_namespace = true
  version          = var.cert_manager_config_version
  namespace        = var.cert_manager_namespace

  values = concat(
    [local.cert_manager_values_default],
      var.cloudflare_enabled ? [local.cert_manager_values_cloudfare] : [],
      var.gcp_enabled ? [local.cert_manager_values_gcp] : [],
      var.azure_enabled ? [local.cert_manager_values_azure] : []
  )
}

