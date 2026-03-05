locals {
  aws_load_balancer_controller_values = templatefile("${path.module}/templates/aws_load_balancer_controller_values.tmpl.yaml", {
    cluster_name         = var.cluster_name
    service_account_name = var.service_account_name
    vpc_id               = var.vpc_id
  })
}
