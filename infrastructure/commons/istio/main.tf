
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

  # Enforce HA on istiod. The chart's HPA is enabled by default with
  # autoscaleMin=1, so setting only replicaCount is not enough — the HPA
  # would scale it back to 1 and re-block any node drain (istiod PDB has
  # minAvailable=1). Setting autoscaleMin locks in the floor.
  set = [
    {
      name  = "pilot.replicaCount"
      value = var.istiod_replicas
    },
    {
      name  = "pilot.autoscaleMin"
      value = var.istiod_replicas
    },
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

  # Enforce HA on istio-ingressgateway. Same class of bug as istiod: the
  # gateway chart ships a default PDB with minAvailable=1, and the HPA is
  # enabled with autoscaling.minReplicas=1, so a single-replica install
  # blocks every node rolling update with PodEvictionFailure. Setting both
  # replicaCount and autoscaling.minReplicas locks in the floor.
  set = [
    {
      name  = "replicaCount"
      value = var.istio_ingressgateway_replicas
    },
    {
      name  = "autoscaling.minReplicas"
      value = var.istio_ingressgateway_replicas
    },
  ]
}
