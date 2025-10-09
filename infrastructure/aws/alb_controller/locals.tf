locals {
  aws_load_balancer_controller_values = templatefile("${path.module}/templates/aws_load_balancer_controller_values.tmpl.yaml", {
    cluster_name         = var.cluster_name
    service_account_name = kubernetes_service_account.aws_load_balancer_controller_sa.metadata[0].name
    vpc_id               = var.vpc_id
  })
}