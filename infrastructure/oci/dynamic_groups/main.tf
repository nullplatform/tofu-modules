resource "oci_identity_dynamic_group" "external_dns" {
  compartment_id = var.tenancy_id # Dynamic groups are always created at tenancy level
  name           = local.dynamic_group_name
  description    = "Dynamic group for external-dns workload identity in OKE"
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
  description    = "Policy to allow external-dns to manage DNS records"
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
