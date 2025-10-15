locals {
  helm_values = templatefile("${path.module}/templates/istio_ingressgateway.tmpl.yaml", {
    service_type      = var.service_type
    status_port       = var.status_port
    https_port        = var.https_port
    https_target_port = var.https_target_port
    enable_http2      = var.enable_http2
    http2_port        = var.http2_port
    http2_target_port = var.http2_target_port

  })

}