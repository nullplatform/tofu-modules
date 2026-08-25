locals {
  # AWS's Load Balancer Controller mutating webhook auto-assigns this
  # loadBalancerClass to any freshly created type=LoadBalancer Service, and
  # the field is immutable afterwards — so it must be declared explicitly on
  # every subsequent upgrade or the API server rejects the patch.
  default_service_load_balancer_class = var.cloud_provider == "aws" && var.service_type == "LoadBalancer" ? "service.k8s.aws/nlb" : ""
  service_load_balancer_class         = var.service_load_balancer_class != null ? var.service_load_balancer_class : local.default_service_load_balancer_class

  helm_values = templatefile("${path.module}/templates/istio_ingressgateway.tmpl.yaml", {
    service_type                 = var.service_type
    status_port                  = var.status_port
    https_port                   = var.https_port
    https_target_port            = var.https_target_port
    enable_http2                 = var.enable_http2
    http2_port                   = var.http2_port
    http2_target_port            = var.http2_target_port
    cloud_provider               = var.cloud_provider
    oci_load_balancer_subnet_ids = var.oci_load_balancer_subnet_ids
    load_balancer_class          = local.service_load_balancer_class
  })
}
