locals {
  checklist_actions = {
    item       = "checklist:item:dispatched"
    validation = "checklist:item:validation_dispatched"
  }

  channel_trigger_plugins = ["np-checklist-trigger", "np-action-item-trigger", "np-scope-trigger", "np-deployment-trigger"]

  # Steps are read with try() because the definition is free-form: a step the
  # API will refuse must reach it, not fail here.
  steps = try(var.definition.steps, {})

  has_channel_trigger = anytrue([
    for step in values(local.steps) : contains(local.channel_trigger_plugins, try(step.pluginType, ""))
  ])

  # The np-checklist-trigger steps that name a kind, with the actions each one
  # listens to: channelActions when set and not empty, else action, which
  # defaults to an item dispatch. A kind of "*" listens to every kind, so no
  # checklist item or validation needs to name it; a kind with a ${{ }}
  # expression is resolved by the engine at activation, so the module cannot
  # know its value. Both are left out.
  checklist_triggers = {
    for id, step in local.steps : id => {
      kind = step.config.kind
      actions = (
        length(try(step.config.channelActions, [])) > 0
        ? tolist(step.config.channelActions)
        : tolist([try(step.config.action, local.checklist_actions.item)])
      )
    }
    if(
      try(step.pluginType, "") == "np-checklist-trigger"
      && try(step.config.kind, "*") != "*"
      && !try(strcontains(step.config.kind, "$${{"), false)
    )
  }

  checklist_item_kinds       = { for id, t in local.checklist_triggers : id => t.kind if contains(t.actions, local.checklist_actions.item) }
  checklist_validation_kinds = { for id, t in local.checklist_triggers : id => t.kind if contains(t.actions, local.checklist_actions.validation) }
}
