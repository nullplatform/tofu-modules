resource "oci_identity_dynamic_group" "external_dns" {
  compartment_id = var.tenancy_id # Dynamic groups siempre se crean a nivel de tenancy
  name           = local.dynamic_group_name
  description    = "Dynamic group para external-dns workload identity en OKE"
  matching_rule  = local.matching_rule

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags

  lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"],
    ]
  }
}


resource "oci_identity_policy" "external_dns" {
  compartment_id = var.compartment_id
  name           = "${var.name_prefix}-external-dns-policy"
  description    = "Policy para permitir a external-dns gestionar DNS records"
  statements     = local.final_policy_statements

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags

  lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"],
    ]
  }
}
