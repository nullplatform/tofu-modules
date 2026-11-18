################################################################################
# Approval action decided by a checklist
#
# One approval action and its link to a checklist specification version. The
# action says which requests need approval (an action, at an NRN, for some
# dimensions) and what a failed checklist does to them; the link says which
# version of a specification they are evaluated against.
################################################################################
locals {
  # deployment:create -> deployment; service:action:create -> service:action.
  entity = regex("^(.*):[^:]+$", var.action)[0]
}

resource "nullplatform_approval_action" "this" {
  nrn               = var.nrn
  entity            = local.entity
  action            = var.action
  dimensions        = var.dimensions
  on_checklist_fail = var.checklist.on_fail

  lifecycle {
    # While an action is linked the provider stops reading its policies back,
    # so the state can keep a list from before the link; no plan detaches it.
    ignore_changes = [policies]
  }
}

resource "nullplatform_approval_action_checklist_specification_association" "this" {
  approval_action_id         = nullplatform_approval_action.this.id
  checklist_specification_id = var.checklist.specification_id
}
