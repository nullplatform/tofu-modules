locals {
  prometheus_server_url = (
    var.prometheus_url != "" ?
    var.prometheus_url :
    "http://prometheus-server.${var.prometheus_namespace}.svc.cluster.local:80"
  )
}
