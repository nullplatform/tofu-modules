locals {
  dynamic_group_name = "${var.name_prefix}-external-dns"

  # Detect if compartment_id is the tenancy root
  is_tenancy_root = var.compartment_id == var.tenancy_id

  # Policy scope: "tenancy" if root, or "compartment id <ocid>" if it's a compartment
  policy_scope = local.is_tenancy_root ? "tenancy" : "compartment id ${var.compartment_id}"

  # Matching rule for OKE Enhanced Workload Identity
  # Matches specific pods based on cluster, namespace and service account
  matching_rule = "ALL {resource.type='workloadidentity',resource.compartment.id='${var.compartment_id}',resource.cluster.id='${var.cluster_id}',resource.kubernetes.namespace='${var.external_dns_namespace}',resource.kubernetes.serviceaccount='${var.external_dns_service_account}'}"

  dns_policy_statements = [
    # Allow inspect, read and use DNS zones
    "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to inspect dns-zones in ${local.policy_scope}",
    "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to read dns-zones in ${local.policy_scope}",
    "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to use dns-zones in ${local.policy_scope}",

    # Allow manage DNS records
    "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to manage dns-records in ${local.policy_scope}",
  ]

  # If specific zone IDs are provided, add restrictions
  dns_policy_statements_restricted = length(var.dns_zone_ids) > 0 ? [
    for zone_id in var.dns_zone_ids : "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to manage dns-records in ${local.policy_scope} where target.dns-zone.id = '${zone_id}'"
  ] : []

  # Use restricted statements if zone IDs are provided, otherwise use general statements
  final_policy_statements = length(var.dns_zone_ids) > 0 ? concat(
    [
      "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to inspect dns-zones in ${local.policy_scope}",
      "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to read dns-zones in ${local.policy_scope}",
      "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to use dns-zones in ${local.policy_scope}"
    ],
    local.dns_policy_statements_restricted
  ) : local.dns_policy_statements
}
