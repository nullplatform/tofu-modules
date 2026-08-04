################################################################################
# Service Specification
################################################################################
# Create service specification resource from processed template
resource "nullplatform_service_specification" "from_template" {
  depends_on = [
    data.external.service_spec
  ]
  name          = var.service_spec_name
  visible_to    = concat(local.service_spec_parsed.visible_to, var.extra_visible_to_nrns)
  assignable_to = local.service_spec_parsed.assignable_to
  type          = local.service_spec_parsed.type
  # The API persists a `values = {}` key inside `attributes` that the
  # template never sets, causing perpetual drift on every plan. Mirroring
  # it here keeps config and state in sync instead of masking the diff.
  attributes          = jsonencode(merge({ values = {} }, local.service_spec_parsed.attributes))
  use_default_actions = local.service_spec_parsed.use_default_actions

  selectors {
    category     = local.service_spec_parsed.selectors.category
    imported     = local.service_spec_parsed.selectors.imported
    provider     = local.service_spec_parsed.selectors.provider
    sub_category = local.service_spec_parsed.selectors.sub_category
  }

  # Resolving to no actions means the caller relied on the default this variable
  # no longer has, and its spec predates `available_actions`. Left alone that is
  # an empty for_each below, which destroys every action specification the scope
  # has registered — silently, since an empty list is not an error.
  #
  # The check lives here and not on the action_specification resource: with an
  # empty for_each that resource has no instances, so its preconditions never run.
  lifecycle {
    precondition {
      condition     = length(local.static_action_specs) > 0
      error_message = <<-EOT
        No actions resolved for scope "${var.service_spec_name}".

        Declare `available_actions` in ${var.service_path}/specs/service-spec.json.tpl,
        or pass `action_spec_names` explicitly.

        Proceeding would destroy every action specification registered for this
        scope: creating and deleting scopes, deploying, blue/green, rollback and
        diagnostics all stop being available from the UI.
      EOT
    }
  }
}

################################################################################
# Scope Type
################################################################################
# Create scope type resource linked to service specification
resource "nullplatform_scope_type" "from_template" {
  depends_on = [
    data.external.scope_type,
  nullplatform_service_specification.from_template]

  nrn           = var.nrn
  name          = var.service_spec_name
  description   = var.service_spec_description
  provider_id   = local.service_specification_id
  provider_type = local.scope_type_def.provider_type
}

################################################################################
# Action Specifications
################################################################################
# Create action specification resources for each action type
resource "nullplatform_action_specification" "from_templates" {
  for_each = local.static_action_specs
  depends_on = [
    data.external.action_specs,
  nullplatform_service_specification.from_template]

  service_specification_id = local.service_specification_id
  name                     = jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).name
  type                     = jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).type
  parameters               = jsonencode(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).parameters)
  results                  = jsonencode(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).results)
  retryable                = try(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).retryable, false)
  icon                     = try(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).icon, "")
  annotations              = jsonencode(try(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).annotations, {}))
}

################################################################################
# NRN Configuration Patch
################################################################################

# Patch NRN with external provider configuration for metrics and logging
resource "null_resource" "nrn_patch" {
  depends_on = [
    nullplatform_action_specification.from_templates,
    nullplatform_scope_type.from_template,
    nullplatform_service_specification.from_template
  ]

  triggers = {
    nrn              = var.nrn
    service_slug     = local.service_slug
    metrics_provider = var.external_metrics_provider
    logging_provider = var.external_logging_provider
  }

  provisioner "local-exec" {
    command = <<-EOT
      np nrn patch --nrn "${var.nrn}" --body "{
        \"global.${local.service_slug}_metric_provider\": \"${var.external_metrics_provider}\",
        \"global.${local.service_slug}_log_provider\": \"${var.external_logging_provider}\"
      }"
    EOT

    environment = {
      NP_API_KEY = var.np_api_key
    }
  }
}

resource "nullplatform_provider_specification" "from_scope_configuration" {
  count = var.create_scope_configuration ? 1 : 0

  # `name` defaults to the template value (`local.scope_configuration.name`)
  # for backwards compatibility. Pass `var.scope_configuration_name_override`
  # to override when the template's name would collide with an existing
  # org-visible provider_specification (sibling-account isolation case).
  name             = coalesce(var.scope_configuration_name_override, local.scope_configuration.name)
  icon             = local.scope_configuration.icon
  description      = local.scope_configuration.description
  category         = local.scope_configuration.category
  allow_dimensions = local.scope_configuration.allow_dimensions
  visible_to       = concat([var.nrn], var.extra_visible_to_nrns)
  schema           = jsonencode(local.scope_configuration.schema)
}
