locals {
  prometheus_values = templatefile("${path.module}/templates/prometheus_values.tmpl.yaml", {
    nullplatform_port = var.nullplatform_port
  })
}