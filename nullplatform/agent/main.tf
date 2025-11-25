################################################################################
# Nullplatform agent Helm release
################################################################################

# Deploy nullplatform agent to Kubernetes cluster via Helm chart
resource "helm_release" "agent" {
  name             = "nullplatform-agent"
  chart            = "nullplatform-agent"
  repository       = "https://nullplatform.github.io/helm-charts"
  namespace        = var.namespace
  version          = var.nullplatform_agent_helm_version
  create_namespace = true

  # Deployment behavior configuration
  disable_webhooks  = true
  force_update      = true
  wait              = true
  wait_for_jobs     = true
  timeout           = 600
  atomic            = true # Rollback on failure
  cleanup_on_fail   = true
  replace           = true
  recreate_pods     = true
  reset_values      = true
  reuse_values      = true
  dependency_update = true
  max_history       = 10

  values = [local.nullplatform_agent_values]
}