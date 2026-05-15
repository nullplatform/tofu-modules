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
  # When routing chart is installed, disable gateway resources in base chart to
  # avoid helm ownership conflicts (both charts declare the same gateway objects).
  values = [
    local.nullplatform_base_values,
    var.install_routing ? "gateways:\n  enabled: false\nglobal:\n  installGatewayV2Crd: false\n" : "",
  ]

  depends_on = [
    kubernetes_namespace_v1.nullplatform_tools,
    kubernetes_namespace_v1.nullplatform_applications,
  ]
}

############################################
# Routing Helm Release
############################################

resource "helm_release" "routing" {
  count      = var.install_routing ? 1 : 0
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
  cleanup_on_fail   = true
  atomic            = true
  create_namespace  = true
  values            = [local.nullplatform_routing_values]

  depends_on = [
    kubernetes_namespace_v1.nullplatform_tools,
  ]
}
