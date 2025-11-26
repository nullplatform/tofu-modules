################################################################################
# Service Specification
################################################################################
# Create service specification resource from processed template
resource "nullplatform_service_specification" "from_template" {
  depends_on = [
    data.external.service_spec
  ]
  name                = var.service_spec_name
  visible_to          = local.service_spec_parsed.visible_to
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

  lifecycle {
    ignore_changes = [name, attributes, type, visible_to]
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
  for_each   = local.static_action_specs
  depends_on = [
    data.external.action_specs,
    nullplatform_service_specification.from_template]

  service_specification_id = local.service_specification_id
  name                     = jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).name
  type                     = jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).type
  parameters               = jsonencode(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).parameters)
  results                  = jsonencode(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).results)
  retryable                = try(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).retryable, false)

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
