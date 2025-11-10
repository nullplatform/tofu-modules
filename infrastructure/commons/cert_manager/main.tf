resource "helm_release" "cert_manager" {
  name             = "cert-manager"
  repository       = "https://charts.jetstack.io"
  chart            = "cert-manager"
  namespace        = var.cert_manager_namespace
  create_namespace = true
  version          = var.cert_manager_version

  set = [
    {
      name  = "crds.enabled"
      value = "true"
    }
  ]

  wait          = true
  wait_for_jobs = true
  timeout       = 600
}

# Esperar a que cert-manager esté completamente listo
resource "time_sleep" "wait_for_cert_manager" {
  depends_on      = [helm_release.cert_manager]
  create_duration = "45s"
}

# Crear el Secret de Cloudflare
resource "kubernetes_secret" "cloudflare_api_token" {
  count = var.cloudflare_enabled ? 1 : 0

  metadata {
    name      = var.cloudflare_secret_name
    namespace = var.cert_manager_namespace
  }

  data = {
    api-token = var.cloudflare_token
  }

  depends_on = [time_sleep.wait_for_cert_manager]
}

resource "helm_release" "cert_manager_config" {
  name             = "cert-manager-config"
  repository       = "https://nullplatform.github.io/helm-charts"
  chart            = "nullplatform-cert-manager-config"
  create_namespace = true
  version          = var.cert_manager_config_version
  namespace        = var.cert_manager_namespace
  values = [local.helm_values]

  depends_on = [kubernetes_secret.cloudflare_api_token]
}