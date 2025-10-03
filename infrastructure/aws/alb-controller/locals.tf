locals {
  aws-load-balancer-controller-values = templatefile("${path.module}/templates/aws-load-balancer-controller-values.tmpl.yaml", {
    cluster_name         = var.cluster_name
    service_account_name = kubernetes_service_account.aws-load-balancer-controller-sa.metadata[0].name
    vpc_id               = var.vpc_id
  })
}