module "aws_load_balancer_controller_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                                = "~> 6.0"
  name                                   = "AWSLoadBalancerControllerIAMRole"
  attach_load_balancer_controller_policy = true
  use_name_prefix                        = false
  oidc_providers = {
    main = {
      provider_arn               = var.aws_iam_openid_connect_provider
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller"]
    }
  }
}

resource "kubernetes_service_account" "aws_load_balancer_controller_sa" {
  metadata {
    name      = "aws-load-balancer-controller"
    namespace = "kube-system"
    labels = {
      "app.kubernetes.io/name"      = "aws-load-balancer-controller"
      "app.kubernetes.io/component" = "controller"
    }
    annotations = {
      "eks.amazonaws.com/role-arn"               = module.aws_load_balancer_controller_role.arn
      "eks.amazonaws.com/sts-regional-endpoints" = "true"
    }
  }
}