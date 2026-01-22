resource "oci_identity_dynamic_group" "this" {
  compartment_id = var.tenancy_id # Dynamic groups are always created at tenancy level
  name           = local.dynamic_group_name
  description    = "Dynamic group for ${var.workload_name} workload identity in OKE"
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

resource "oci_identity_policy" "this" {
  compartment_id = var.compartment_id
  name           = "${var.name_prefix}-${var.workload_name}-policy"
  description    = "Policy for ${var.workload_name} workload identity"
  statements     = var.policy_statements

  defined_tags  = var.defined_tags
  freeform_tags = var.freeform_tags

  lifecycle {
    ignore_changes = [
      defined_tags["Oracle-Tags.CreatedBy"],
      defined_tags["Oracle-Tags.CreatedOn"],
    ]
  }
}
