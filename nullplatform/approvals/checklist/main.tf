################################################################################
# Checklist specification
#
# One specification: a name at an NRN. Every change of its definition or
# description is a new version, and current_version_id follows the newest one.
################################################################################
resource "nullplatform_checklist_specification" "this" {
  nrn         = var.nrn
  name        = var.name
  description = var.description
  definition  = jsonencode(var.definition)

  lifecycle {
    # A new name or NRN replaces the specification, and the API refuses to
    # delete one while an approval action is linked to it. Creating the new one
    # first lets the links move to it before the old one is deleted.
    create_before_destroy = true
  }
}
