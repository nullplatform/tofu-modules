################################################################################
# nullplatform Agent Helm Release
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
  replace           = false
  recreate_pods     = false
  reset_values      = false
  reuse_values      = false
  dependency_update = true
  max_history       = 10

  values = concat(
    var.cloud_provider == "aws" ? [local.nullplatform_agent_values_aws] : [],
    var.cloud_provider == "gcp" ? [local.nullplatform_agent_values_gcp] : [],
    var.cloud_provider == "azure" ? [local.nullplatform_agent_values_azure] : []
  )
}