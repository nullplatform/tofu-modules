locals {
  prometheus_server_url = (
    var.prometheus_url != "" ?
    var.prometheus_url :
    "http://prometheus-server.${var.prometheus_namespace}.svc.cluster.local:80"
  )
  prometheus_values = templatefile("${path.module}/templates/prometheus_values.tmpl.yaml", {
    nullplatform_port = var.nullplatform_port
  })
}