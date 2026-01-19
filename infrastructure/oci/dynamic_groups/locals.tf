locals {
  dynamic_group_name = "${var.name_prefix}-external-dns"

  # Matching rule para OKE Enhanced Workload Identity
  # Esto matchea pods específicos basándose en el cluster, namespace y service account
  matching_rule = "ALL {resource.type='workloadidentity',resource.compartment.id='${var.compartment_id}',resource.cluster.id='${var.cluster_id}',resource.kubernetes.namespace='${var.external_dns_namespace}',resource.kubernetes.serviceaccount='${var.external_dns_service_account}'}"
  dns_policy_statements = [
    # Permite leer DNS zones en el compartment
    "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to read dns-zones in compartment id ${var.compartment_id}",

    # Permite gestionar records en DNS zones
    "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to manage dns-records in compartment id ${var.compartment_id}",
  ]

  # Si se especifican zone IDs específicos, agregar restricciones
  dns_policy_statements_restricted = length(var.dns_zone_ids) > 0 ? [
    for zone_id in var.dns_zone_ids : "Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to manage dns-records in compartment id ${var.compartment_id} where target.dns-zone.id = '${zone_id}'"
  ] : []

  # Usar statements restringidos si hay zone IDs, sino usar los generales
  final_policy_statements = length(var.dns_zone_ids) > 0 ? concat(
    ["Allow dynamic-group ${oci_identity_dynamic_group.external_dns.name} to read dns-zones in compartment id ${var.compartment_id}"],
    local.dns_policy_statements_restricted
  ) : local.dns_policy_statements
}