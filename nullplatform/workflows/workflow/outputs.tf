output "id" {
  description = "Id of the workflow (wf_...): what other workflows and aliases refer to it by."
  value       = nullplatform_workflow.this.id
}

output "key" {
  description = "Key of the workflow, or null when it has none."
  value       = nullplatform_workflow.this.key
}

output "revision" {
  description = "Number of the latest revision. It changes with every new definition."
  value       = nullplatform_workflow.this.revision
}

output "alias" {
  description = "Name of the alias, or null when the module creates none."
  value       = one(nullplatform_workflow_alias.this[*].name)
}

output "webhook_urls" {
  description = "Webhook URL of each trigger of the alias's revision that has one, by trigger id. Empty while the alias is inactive or absent. Sensitive: the URL ends in a capability token."
  value       = length(nullplatform_workflow_alias.this) == 0 ? {} : nullplatform_workflow_alias.this[0].webhook_urls
  sensitive   = true
}

output "checklist_item_kinds" {
  description = "The kind each np-checklist-trigger that listens to item dispatches serves, by trigger id: the key is the workflow's trigger id, not the checklist item's id. A checklist's external item takes its kind from here, so the checklist is published once the workflow listens. Triggers of kind \"*\" are left out, and so are kinds with a $${{ }} expression, which the engine resolves at activation: the module cannot know their value."
  value       = local.checklist_item_kinds

  # The checklist that reads this must wait for the alias: until it is active,
  # an item dispatched with this kind finds no channel.
  depends_on = [nullplatform_workflow_alias.this]
}

output "checklist_validation_kinds" {
  description = "The kind each np-checklist-trigger that listens to validation dispatches serves, by trigger id: the key is the workflow's trigger id, not the checklist item's id. A manual item's external validation takes its kind from here, so the checklist is published once the workflow listens. Triggers of kind \"*\" are left out, and so are kinds with a $${{ }} expression, which the engine resolves at activation: the module cannot know their value."
  value       = local.checklist_validation_kinds

  depends_on = [nullplatform_workflow_alias.this]
}
