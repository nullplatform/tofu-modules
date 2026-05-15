############################################
# Namespaces
# Pre-create namespaces to avoid race condition
# with Helm chart's lookup function
############################################

resource "kubernetes_manifest" "nullplatform_tools" {
  manifest = {
    apiVersion = "v1"
    kind       = "Namespace"
    metadata = {
      name        = var.namespace
      labels      = { name = var.namespace }
      annotations = { "openshift.io/cluster-monitoring" = "true" }
    }
  }
  field_manager {
    force_conflicts = true
  }
}

resource "kubernetes_manifest" "gateways" {
  manifest = {
    apiVersion = "v1"
    kind       = "Namespace"
    metadata = {
      name   = var.gateway_namespace
      labels = { name = var.gateway_namespace }
    }
  }
  field_manager {
    force_conflicts = true
  }
}

############################################
# Helm Release
############################################

resource "helm_release" "routing" {
  name       = "nullplatform-routing"
  chart      = var.nullplatform_routing_chart_path != "" ? var.nullplatform_routing_chart_path : "nullplatform-routing"
  repository = var.nullplatform_routing_chart_path != "" ? null : "https://nullplatform.github.io/helm-charts"
  namespace  = var.namespace
  version    = var.nullplatform_routing_chart_path != "" && !startswith(var.nullplatform_routing_chart_path, "oci://") ? null : var.nullplatform_routing_helm_version

  wait_for_jobs     = true
  timeout           = 600
  reset_values      = true
  dependency_update = true
  max_history       = 10
  values            = [local.nullplatform_routing_values]

  depends_on = [
    kubernetes_manifest.nullplatform_tools,
    kubernetes_manifest.gateways,
  ]
}
