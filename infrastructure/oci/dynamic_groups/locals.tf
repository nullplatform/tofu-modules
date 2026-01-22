locals {
  dynamic_group_name = "${var.name_prefix}-${var.workload_name}"

  # Detect if compartment_id is the tenancy root
  is_tenancy_root = var.compartment_id == var.tenancy_id

  # Policy scope: "tenancy" if root, or "compartment id <ocid>" if it's a compartment
  policy_scope = local.is_tenancy_root ? "tenancy" : "compartment id ${var.compartment_id}"

  # Matching rule for OKE Enhanced Workload Identity
  # Matches specific pods based on cluster, namespace and service account
  matching_rule = "ALL {resource.type='workloadidentity',resource.compartment.id='${var.compartment_id}',resource.cluster.id='${var.cluster_id}',resource.kubernetes.namespace='${var.namespace}',resource.kubernetes.serviceaccount='${var.service_account}'}"

  # Base workload identity conditions (without the all{} wrapper)
  # This is the recommended approach for OKE Enhanced Cluster workload identity
  workload_identity_conditions = "request.principal.type = 'workload', request.principal.namespace = '${var.namespace}', request.principal.service_account = '${var.service_account}', request.principal.cluster_id = '${var.cluster_id}'"

  # DNS policy statements using direct request.principal.* approach (recommended for workload identity)
  dns_policy_statements = var.enable_dns_permissions ? [
    "Allow any-user to inspect dns-zones in ${local.policy_scope} where all {${local.workload_identity_conditions}}",
    "Allow any-user to read dns-zones in ${local.policy_scope} where all {${local.workload_identity_conditions}}",
    "Allow any-user to use dns-zones in ${local.policy_scope} where all {${local.workload_identity_conditions}}",
    "Allow any-user to manage dns-records in ${local.policy_scope} where all {${local.workload_identity_conditions}}",
  ] : []

  # Combine DNS statements with custom policy statements
  final_policy_statements = concat(local.dns_policy_statements, var.additional_policy_statements)
}
