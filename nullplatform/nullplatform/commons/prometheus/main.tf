resource "helm_release" "prometheus" {
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
      "url" : "http://prometheus-server.${var.prometheus_namespace}.svc.cluster.local:80"
    }
  })
  dimensions = {}

  lifecycle {
    ignore_changes = [attributes]
  }
}