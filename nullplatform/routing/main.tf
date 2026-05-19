############################################
# Helm Release
#
# Namespaces are NOT pre-created by Terraform:
#   - `nullplatform-tools` (release namespace) is created by `nullplatform/base`
#   - `gateways` is created by the chart itself (Namespace template with
#      helm.sh/resource-policy: keep). Helm adopts the namespace on install if
#      it already exists with matching ownership annotations.
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
}
