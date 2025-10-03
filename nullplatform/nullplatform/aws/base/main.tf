resource "helm_release" "base" {
  name             = "nullplatform-base"
  chart            = "nullplatform-base"
  repository       = "https://nullplatform.github.io/helm-charts"
  namespace        = var.namespace
  version          = var.nullplatform-base-helm-version
  create_namespace = true

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

  values = [local.nullplatform_base_values]
}