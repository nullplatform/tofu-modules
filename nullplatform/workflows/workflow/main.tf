################################################################################
# Workflow
#
# One workflow: a record (name, key, folder, NRN) and its definition. Every
# change of the definition is a new revision, and revision follows the newest.
################################################################################
resource "nullplatform_workflow" "this" {
  nrn         = var.nrn
  key         = var.key
  name        = var.name
  description = var.description
  path        = var.folder
  definition  = jsonencode(var.definition)

  lifecycle {
    # Without an alias nothing registers the triggers, so a channel trigger
    # would never listen: say so here instead of publishing a workflow that
    # looks complete.
    precondition {
      condition     = var.alias != null || length(local.channel_trigger_steps) == 0
      error_message = "A definition with a channel trigger (np-checklist-trigger, np-action-item-trigger, np-scope-trigger, np-deployment-trigger) needs an alias: the alias registers the trigger. Set alias, or remove the trigger."
    }
  }
}

################################################################################
# Alias
#
# The alias serves a revision and, while active, registers its triggers. It
# takes the revision from the workflow, so a new definition moves it in the same
# apply.
################################################################################
resource "nullplatform_workflow_alias" "this" {
  count = var.alias == null ? 0 : 1

  workflow_id = nullplatform_workflow.this.id
  name        = var.alias
  revision    = nullplatform_workflow.this.revision
  active      = var.active
}
