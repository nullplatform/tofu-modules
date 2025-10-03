locals {
  prometheus_values = templatefile("${path.module}/templates/prometheus-values.tmpl.yaml", {
    nullplatform_port = var.nullplatform_port
  })
}