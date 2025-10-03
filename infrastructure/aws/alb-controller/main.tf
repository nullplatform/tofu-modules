resource "helm_release" "aws-load-balancer-controller" {
  name       = "aws-load-balancer-controller"
  repository = "https://aws.github.io/eks-charts"
  chart      = "aws-load-balancer-controller"
  version    = var.aws-load-balancer-controller-version
  namespace  = "kube-system"

  disable_webhooks  = true
  force_update      = true
  wait              = true
  wait_for_jobs     = true
  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true
  replace           = false
  recreate_pods     = false
  reset_values      = false
  reuse_values      = false
  dependency_update = true
  max_history       = 10


  values = [local.aws-load-balancer-controller-values]
}