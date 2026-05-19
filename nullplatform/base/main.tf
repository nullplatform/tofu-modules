############################################
# Namespaces
# Pre-create namespaces to avoid race condition
# with Helm chart's lookup function (chart v2.36.0+)
############################################

resource "kubernetes_namespace_v1" "nullplatform_tools" {
  metadata {
    name        = var.namespace
    labels      = { name = var.namespace }
    annotations = { "openshift.io/cluster-monitoring" = "true" }
  }
}

resource "kubernetes_namespace_v1" "nullplatform_applications" {
  metadata {
    name   = "nullplatform"
    labels = { name = "nullplatform" }
  }
}

############################################
# Helm Release
############################################

resource "helm_release" "base" {
  name       = "nullplatform-base"
  chart      = var.nullplatform_base_chart_path != "" ? var.nullplatform_base_chart_path : "nullplatform-base"
  repository = var.nullplatform_base_chart_path != "" ? null : "https://nullplatform.github.io/helm-charts"
  namespace  = var.namespace
  version    = var.nullplatform_base_chart_path != "" && !startswith(var.nullplatform_base_chart_path, "oci://") ? null : var.nullplatform_base_helm_version

  wait_for_jobs     = true
  timeout           = 600
  reset_values      = true
  dependency_update = true
  max_history       = 10
  cleanup_on_fail   = true
  atomic            = true
  values            = [local.nullplatform_base_values]

  depends_on = [
    kubernetes_namespace_v1.nullplatform_tools,
    kubernetes_namespace_v1.nullplatform_applications,
  ]
}
