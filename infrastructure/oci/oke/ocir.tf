# ---------------------------------------------------------
# OCIR (Oracle Container Image Registry) Access Policies
# ---------------------------------------------------------
# This creates IAM policies that allow:
# 1. OKE worker nodes (instances) to pull images from OCIR
# 2. OKE workloads (pods) to pull images from OCIR via Workload Identity

locals {
  # Validate tenancy_id is provided when enable_ocir_pull is true
  validate_tenancy_id = var.enable_ocir_pull && var.tenancy_id == null ? tobool("tenancy_id is required when enable_ocir_pull is true") : true

  # Build policy statements for workload identity (pods)
  ocir_workload_policy_statements = var.enable_ocir_pull ? (
    length(var.ocir_pull_namespaces) > 0
    ? [for ns in var.ocir_pull_namespaces :
      "Allow any-user to read repos in tenancy where all {request.principal.type = 'workload', request.principal.namespace = '${ns}', request.principal.cluster_id = '${module.oke.cluster_id}'}"
    ]
    : ["Allow any-user to read repos in tenancy where all {request.principal.type = 'workload', request.principal.cluster_id = '${module.oke.cluster_id}'}"]
  ) : []

  # Policy statement for worker nodes (instances) to pull images
  ocir_nodes_policy_statements = var.enable_ocir_pull ? [
    "Allow any-user to read repos in tenancy where all {request.principal.type = 'instance', request.principal.compartment.id = '${var.compartment_id}'}"
  ] : []
}

# Policy for OKE workloads (pods) - Workload Identity
resource "oci_identity_policy" "ocir_workload_identity" {
  count          = var.enable_ocir_pull ? 1 : 0
  provider       = oci.home
  compartment_id = var.tenancy_id
  name           = "${var.cluster_name}-ocir-workload-identity"
  description    = "Allow OKE workloads in cluster ${var.cluster_name} to pull images from OCIR"
  statements     = local.ocir_workload_policy_statements

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}

# Policy for OKE worker nodes (instances) - Required for image pulls
resource "oci_identity_policy" "ocir_nodes" {
  count          = var.enable_ocir_pull ? 1 : 0
  provider       = oci.home
  compartment_id = var.tenancy_id
  name           = "${var.cluster_name}-ocir-nodes"
  description    = "Allow OKE worker nodes in cluster ${var.cluster_name} to pull images from OCIR"
  statements     = local.ocir_nodes_policy_statements

  lifecycle {
    ignore_changes = [defined_tags, freeform_tags]
  }
}
