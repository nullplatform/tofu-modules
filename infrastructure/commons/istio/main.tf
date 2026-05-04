
resource "helm_release" "istio_base" {
  name       = "istio-base"
  repository = var.repository
  chart      = "base"
  namespace  = var.namespace
  version    = var.istio_base_version

  create_namespace  = true
  disable_webhooks  = false
  force_update      = true
  wait              = true
  wait_for_jobs     = true
  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true
  replace           = true
  recreate_pods     = true
  reset_values      = true
  reuse_values      = false
  dependency_update = true
  max_history       = 10

}

resource "helm_release" "istiod" {
  name       = "istiod"
  depends_on = [helm_release.istio_base]
  repository = var.repository
  chart      = "istiod"
  namespace  = var.namespace
  version    = var.istiod_version

  create_namespace  = true
  disable_webhooks  = false
  force_update      = true
  wait              = true
  wait_for_jobs     = true
  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true
  replace           = true
  recreate_pods     = true
  reset_values      = true
  reuse_values      = false
  dependency_update = true
  max_history       = 10

  # Only forward `pilot.replicaCount` when the operator opts in. With the
  # default `null` we omit the override entirely, preserving the chart's
  # own default and keeping the module backward-compatible for existing
  # consumers. See `variables.tf` for the recommended value (2).
  set = var.istiod_replica_count == null ? [] : [
    {
      name  = "pilot.replicaCount"
      value = tostring(var.istiod_replica_count)
    }
  ]
}

# Setup Istio Gateway using Helm
resource "helm_release" "istio_ingressgateway" {
  name       = "istio-ingressgateway"
  depends_on = [helm_release.istiod]
  repository = var.repository
  chart      = "gateway"
  namespace  = var.namespace
  version    = var.istio_ingressgateway_version

  create_namespace  = true
  disable_webhooks  = false
  force_update      = true
  wait              = true
  wait_for_jobs     = true
  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true
  replace           = true
  recreate_pods     = true
  reset_values      = true
  reuse_values      = false
  dependency_update = true
  max_history       = 10

  values = [local.helm_values]


}
