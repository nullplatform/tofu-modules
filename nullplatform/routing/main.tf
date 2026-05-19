############################################
# Ownership migration
#
# If the gateways namespace already exists (owned by nullplatform-base from a
# previous installation), patch its Helm ownership annotations before the
# routing chart install. Helm refuses to adopt resources whose
# meta.helm.sh/release-name does not match the incoming release.
#
# Runs only on the first apply of this module (triggers_replace is stable).
# Safe on fresh installs: exits immediately when the namespace does not exist.
############################################

resource "terraform_data" "adopt_gateways_resources" {
  triggers_replace = [var.gateway_namespace, var.namespace]

  provisioner "local-exec" {
    interpreter = ["/bin/bash", "-c"]
    command     = <<-EOT
      GATEWAY_NS="${var.gateway_namespace}"
      RELEASE_NS="${var.namespace}"

      kubectl get namespace "$GATEWAY_NS" &>/dev/null || exit 0

      kubectl annotate namespace "$GATEWAY_NS" \
        "meta.helm.sh/release-name=nullplatform-routing" \
        "meta.helm.sh/release-namespace=$RELEASE_NS" \
        "helm.sh/resource-policy=keep" \
        --overwrite
      kubectl label namespace "$GATEWAY_NS" \
        "app.kubernetes.io/managed-by=Helm" --overwrite

      for RT in deployment service poddisruptionbudget gateway horizontalpodautoscaler; do
        kubectl get "$RT" -n "$GATEWAY_NS" -o name 2>/dev/null | while read R; do
          kubectl annotate "$R" -n "$GATEWAY_NS" \
            "meta.helm.sh/release-name=nullplatform-routing" \
            "meta.helm.sh/release-namespace=$RELEASE_NS" \
            --overwrite
          kubectl label "$R" -n "$GATEWAY_NS" \
            "app.kubernetes.io/managed-by=Helm" --overwrite
        done
      done
    EOT
  }
}

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

  depends_on = [terraform_data.adopt_gateways_resources]
}
