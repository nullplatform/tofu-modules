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

# Transparent migration: if the gateways namespace was previously managed by
# nullplatform-base (before the routing chart existed), patch its Helm ownership
# annotations before the routing chart tries to install. On fresh installs where
# the namespace does not exist yet, this is a no-op.
resource "terraform_data" "adopt_gateways_namespace" {
  count = var.install_routing ? 1 : 0

  provisioner "local-exec" {
    when    = create
    command = <<-EOT
      # Transfer namespace ownership if not already owned by nullplatform-routing
      NS_OWNER=$(kubectl get namespace "${var.gateway_namespace}" \
        -o jsonpath='{.metadata.annotations.meta\.helm\.sh/release-name}' 2>/dev/null || echo "")
      if [ -n "$NS_OWNER" ] && [ "$NS_OWNER" != "nullplatform-routing" ]; then
        kubectl annotate namespace "${var.gateway_namespace}" \
          "meta.helm.sh/release-name=nullplatform-routing" \
          "meta.helm.sh/release-namespace=${var.namespace}" \
          --overwrite
        kubectl label namespace "${var.gateway_namespace}" \
          "app.kubernetes.io/managed-by=Helm" \
          --overwrite
      fi

      # Always transfer ownership of resources owned by nullplatform-base regardless
      # of namespace annotation — handles cases where the namespace was kept from a
      # prior migration but resources were recreated by the base chart.
      # Also adds helm.sh/resource-policy=keep so the base chart upgrade does not
      # delete them, preserving LoadBalancer IPs.
      for RESOURCE_TYPE in deployment service poddisruptionbudget gateway horizontalpodautoscaler; do
        kubectl get "$RESOURCE_TYPE" -n "${var.gateway_namespace}" \
          -o json 2>/dev/null \
        | jq -r '.items[]? | select(.metadata.annotations["meta.helm.sh/release-name"] == "nullplatform-base") | .metadata.name' \
        | while read -r NAME; do
          [ -z "$NAME" ] && continue
          kubectl annotate "$RESOURCE_TYPE" "$NAME" -n "${var.gateway_namespace}" \
            "meta.helm.sh/release-name=nullplatform-routing" \
            "meta.helm.sh/release-namespace=${var.namespace}" \
            "helm.sh/resource-policy=keep" \
            --overwrite 2>/dev/null || true
          kubectl label "$RESOURCE_TYPE" "$NAME" -n "${var.gateway_namespace}" \
            "app.kubernetes.io/managed-by=Helm" \
            --overwrite 2>/dev/null || true
        done
      done
    EOT
  }
}

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
    terraform_data.adopt_gateways_namespace,
    kubernetes_namespace_v1.nullplatform_tools,
    helm_release.base,
  ]
}
