resource "helm_release" "prometheus" {
  count            = var.install_prometheus ? 1 : 0
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "prometheus"
  namespace        = var.prometheus_namespace
  create_namespace = true

  values = [local.prometheus_values]
}

resource "nullplatform_provider_config" "prometheus" {
  nrn  = var.nrn
  type = "prometheus"
  attributes = jsonencode({
    "server" : {
      "url" = local.prometheus_server_url
    }
  })
  dimensions = var.dimensions

  lifecycle {
    ignore_changes = [attributes]
  }
}