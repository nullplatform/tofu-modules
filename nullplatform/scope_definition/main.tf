################################################################################
# Service Specification
################################################################################
# Create service specification resource from processed template
resource "nullplatform_service_specification" "from_template" {
  depends_on = [
    data.external.service_spec
  ]
  name                = var.service_spec_name
  description         = var.service_spec_description
  visible_to          = concat(local.service_spec_parsed.visible_to, var.extra_visible_to_nrns)
  assignable_to       = local.service_spec_parsed.assignable_to
  type                = local.service_spec_parsed.type
  attributes          = jsonencode(local.service_spec_parsed.attributes)
  use_default_actions = local.service_spec_parsed.use_default_actions

  selectors {
    category     = local.service_spec_parsed.selectors.category
    imported     = local.service_spec_parsed.selectors.imported
    provider     = local.service_spec_parsed.selectors.provider
    sub_category = local.service_spec_parsed.selectors.sub_category
  }

  # `visible_to` deliberately NOT in ignore_changes so updates from
  # `var.extra_visible_to_nrns` flow via `tofu apply`. The other ignored
  # attributes (name, attributes, type) are server-enriched after create.
  lifecycle {
    ignore_changes = [name, attributes, type]
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

  # `provider_type` is read from a `data.external` (gomplate-rendered template)
  # which Terraform plans as `(known after apply)`. Combined with the provider
  # marking `provider_type` as ForceNew, every plan triggers a phantom replace
  # even when the upstream template value is unchanged. `status` is server-
  # managed (not user-set). Ignoring both is safe — neither field can be
  # mutated after create in any meaningful way — and prevents the false
  # `must be replaced` diff that would otherwise destroy and re-create the
  # scope_type on every apply.
  lifecycle {
    ignore_changes = [provider_type, status]
  }
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

  lifecycle {
    ignore_changes = [name, annotations, parameters, results, type, retryable]
  }
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
  description      = local.scope_configuration.description
  category         = local.scope_configuration.category
  allow_dimensions = local.scope_configuration.allow_dimensions
  visible_to       = concat([var.nrn], var.extra_visible_to_nrns)
  schema           = jsonencode(local.scope_configuration.schema)
}
