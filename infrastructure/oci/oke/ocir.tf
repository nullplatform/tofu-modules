# ---------------------------------------------------------
# OCIR (Oracle Container Image Registry) Workload Identity
# ---------------------------------------------------------
# This creates an IAM policy that allows OKE workloads to pull
# images from OCIR without needing image pull secrets.

locals {
  # Validate tenancy_id is provided when enable_ocir_pull is true
  validate_tenancy_id = var.enable_ocir_pull && var.tenancy_id == null ? tobool("tenancy_id is required when enable_ocir_pull is true") : true

  # Build policy statements based on namespace configuration
  ocir_policy_statements = var.enable_ocir_pull ? (
    length(var.ocir_pull_namespaces) > 0
    ? [for ns in var.ocir_pull_namespaces :
      "Allow any-user to read repos in tenancy where all {request.principal.type = 'workload', request.principal.namespace = '${ns}', request.principal.cluster_id = '${module.oke.cluster_id}'}"
    ]
    : ["Allow any-user to read repos in tenancy where all {request.principal.type = 'workload', request.principal.cluster_id = '${module.oke.cluster_id}'}"]
  ) : []
}

resource "oci_identity_policy" "ocir_workload_identity" {
  count          = var.enable_ocir_pull ? 1 : 0
  provider       = oci.home
  compartment_id = var.tenancy_id
  name           = "${var.cluster_name}-ocir-workload-identity"
  description    = "Allow OKE workloads in cluster ${var.cluster_name} to pull images from OCIR"
  statements     = local.ocir_policy_statements

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}
