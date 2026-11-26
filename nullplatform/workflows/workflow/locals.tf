locals {
  checklist_actions = {
    item       = "checklist:item:dispatched"
    validation = "checklist:item:validation_dispatched"
  }

  channel_trigger_plugins = ["np-checklist-trigger", "np-action-item-trigger", "np-scope-trigger", "np-deployment-trigger"]

  # Steps are read with try() because the definition is free-form: a step the
  # API will refuse must reach it, not fail here.
  channel_trigger_steps = {
    for id, step in try(var.definition.steps, {}) : id => step
    if contains(local.channel_trigger_plugins, try(step.pluginType, ""))
  }

  # The np-checklist-trigger steps that name a kind, with the actions each one
  # listens to: channelActions when set and not empty, else action, which
  # defaults to an item dispatch. A kind of "*" listens to every kind, so no
  # checklist item or validation needs to name it.
  checklist_trigger_actions = {
    for id, step in try(var.definition.steps, {}) : id => (
      length(try(step.config.channelActions, [])) > 0
      ? tolist(step.config.channelActions)
      : tolist([try(step.config.action, local.checklist_actions.item)])
    )
    if try(step.pluginType, "") == "np-checklist-trigger" && try(step.config.kind, "*") != "*"
  }

  item_kinds = {
    for id, actions in local.checklist_trigger_actions : id => var.definition.steps[id].config.kind
    if contains(actions, local.checklist_actions.item)
  }

  validation_kinds = {
    for id, actions in local.checklist_trigger_actions : id => var.definition.steps[id].config.kind
    if contains(actions, local.checklist_actions.validation)
  }
}
