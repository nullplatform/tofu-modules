resource "nullplatform_service_specification" "from_template" {
  name                = var.service_name
  visible_to          = local.visible_to_nrns
  type                = local.service_spec_parsed.type
  attributes          = jsonencode(local.service_spec_parsed.attributes)
  use_default_actions = local.service_spec_parsed.use_default_actions

  selectors {
    category     = local.service_spec_parsed.selectors.category
    imported     = local.service_spec_parsed.selectors.imported
    provider     = local.service_spec_parsed.selectors.provider
    sub_category = local.service_spec_parsed.selectors.sub_category
  }
  dimensions = jsonencode(var.dimensions)
}

resource "nullplatform_action_specification" "from_templates" {
  for_each   = toset(local.available_actions)
  depends_on = [nullplatform_service_specification.from_template]

  service_specification_id = local.service_specification_id
  name                     = local.action_specs_parsed[each.key].name
  type                     = local.action_specs_parsed[each.key].type
  parameters               = jsonencode(local.action_specs_parsed[each.key].parameters)
  results                  = jsonencode(local.action_specs_parsed[each.key].results)
  retryable                = try(local.action_specs_parsed[each.key].retryable, false)
  annotations              = try(jsonencode(local.action_specs_parsed[each.key].annotations), null)
}

resource "nullplatform_link_specification" "from_templates" {
  for_each   = toset(local.available_links)
  depends_on = [nullplatform_service_specification.from_template]

  name                = local.link_specs_parsed[each.key].name
  unique              = try(local.link_specs_parsed[each.key].unique, false)
  specification_id    = local.service_specification_id
  attributes          = jsonencode(local.link_specs_parsed[each.key].attributes)
  use_default_actions = try(local.link_specs_parsed[each.key].use_default_actions, true)
  selectors {
    category     = local.service_spec_parsed.selectors.category
    imported     = local.service_spec_parsed.selectors.imported
    provider     = local.service_spec_parsed.selectors.provider
    sub_category = local.service_spec_parsed.selectors.sub_category
  }
}
