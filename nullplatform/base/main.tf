############################################
# Namespaces
# Pre-create namespaces to avoid race condition
# with Helm chart's lookup function (chart v2.36.0+)
############################################

resource "kubernetes_namespace_v1" "nullplatform_tools" {
  metadata {
    name = var.namespace
    labels = {
      name = var.namespace
    }
    annotations = {
      "openshift.io/cluster-monitoring" = "true"
    }
  }
}

resource "kubernetes_namespace_v1" "nullplatform_applications" {
  metadata {
    name = "nullplatform"
    labels = {
      name = "nullplatform"
    }
  }
}

############################################
# Helm Release
############################################

resource "helm_release" "base" {
  name       = "nullplatform-base"
  chart      = "nullplatform-base"
  repository = "https://nullplatform.github.io/helm-charts"
  namespace  = var.namespace
  version    = var.nullplatform_base_helm_version

  create_namespace  = false
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
  values            = [local.nullplatform_base_values]

  depends_on = [
    kubernetes_namespace_v1.nullplatform_tools,
    kubernetes_namespace_v1.nullplatform_applications
  ]
}
