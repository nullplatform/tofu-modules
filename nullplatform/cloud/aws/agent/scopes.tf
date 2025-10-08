################################################################################
# Template Fetching
################################################################################

# Fetch service specification template from GitHub repository
data "http" "service_spec_template" {
  url = "${var.github_repo_url}/raw/${var.github_ref}/${var.service_path}/specs/service-spec.json.tpl"
}

# Fetch scope type definition template from GitHub repository
data "http" "scope_type_template" {
  url = "${var.github_repo_url}/raw/${var.github_ref}/${var.service_path}/specs/scope-type-definition.json.tpl"
}

# Fetch all action specification templates from GitHub repository
data "http" "action_templates" {
  for_each = toset(var.action_spec_names)
  url      = "${var.github_repo_url}/raw/${var.github_ref}/${var.service_path}/specs/actions/${each.key}.json.tpl"
}

################################################################################
# Service Specification
################################################################################

# Process service specification template using gomplate with NRN variable
data "external" "service_spec" {
  program = ["sh", "-c", <<-EOT
    processed_json=$(echo '${data.http.service_spec_template.response_body}' | NRN='${var.nrn}' gomplate)
    echo "{\"json\":\"$(echo "$processed_json" | sed 's/"/\\"/g' | tr -d '\n')\"}"
  EOT
  ]
}

locals {
  service_spec_parsed = jsondecode(data.external.service_spec.result.json)
}

# Create service specification resource from processed template
resource "nullplatform_service_specification" "from_template" {
  name                = local.service_spec_parsed.name
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
    ignore_changes = [attributes]
  }
}

# Extract service specification details for use in dependent resources
locals {
  service_specification_id = nullplatform_service_specification.from_template.id
  service_slug             = nullplatform_service_specification.from_template.slug

  # Environment variables for template processing in dependent resources
  dependent_env_vars = {
    NRN                      = var.nrn
    SERVICE_SPECIFICATION_ID = local.service_specification_id
    SERVICE_SLUG             = local.service_slug
    SERVICE_PATH             = var.service_path
    REPO_PATH                = var.repo_path
  }
}

################################################################################
# Scope Type
################################################################################

# Process scope type template with service specification context
data "external" "scope_type" {
  depends_on = [nullplatform_service_specification.from_template]

  program = ["sh", "-c", <<-EOT
    processed_json=$(echo '${data.http.scope_type_template.response_body}' | \
    NRN='${local.dependent_env_vars.NRN}' \
    SERVICE_SPECIFICATION_ID='${local.dependent_env_vars.SERVICE_SPECIFICATION_ID}' \
    gomplate)
    echo "{\"json\":\"$(echo "$processed_json" | sed 's/"/\\"/g' | tr -d '\n')\"}"
  EOT
  ]
}

locals {
  scope_type_def = jsondecode(data.external.scope_type.result.json)
}

# Create scope type resource linked to service specification
resource "nullplatform_scope_type" "from_template" {
  depends_on = [nullplatform_service_specification.from_template]

  nrn         = var.nrn
  name        = local.scope_type_def.name
  description = local.scope_type_def.description
  provider_id = local.service_specification_id
}

################################################################################
# Action Specifications
################################################################################

# Process all action specification templates with full service context
data "external" "action_specs" {
  for_each   = toset(var.action_spec_names)
  depends_on = [nullplatform_service_specification.from_template]

  program = ["sh", "-c", <<-EOT
    processed_json=$(echo '${try(data.http.action_templates[each.key].response_body, "{}")}' | \
    NRN='${local.dependent_env_vars.NRN}' \
    SERVICE_SPECIFICATION_ID='${local.dependent_env_vars.SERVICE_SPECIFICATION_ID}' \
    SERVICE_SLUG='${local.dependent_env_vars.SERVICE_SLUG}' \
    SERVICE_PATH='${local.dependent_env_vars.SERVICE_PATH}' \
    REPO_PATH='${local.dependent_env_vars.REPO_PATH}' \
    gomplate)
    echo "{\"json_b64\":\"$(echo "$processed_json" | base64 -w 0)\"}"
  EOT
  ]
}

# Static set to prevent for_each dependency issues during terraform plan/apply
locals {
  static_action_specs = toset(var.action_spec_names)
}

# Create action specification resources for each action type
resource "nullplatform_action_specification" "from_templates" {
  for_each   = local.static_action_specs
  depends_on = [nullplatform_service_specification.from_template]

  service_specification_id = local.service_specification_id
  name                     = jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).name
  type                     = jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).type
  parameters               = jsonencode(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).parameters)
  results                  = jsonencode(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).results)
  retryable                = try(jsondecode(base64decode(data.external.action_specs[each.key].result.json_b64)).retryable, false)

  lifecycle {
    ignore_changes = [annotations]
  }
}

################################################################################
# NRN Configuration Patch
################################################################################

# Patch NRN with external provider configuration for metrics and logging
resource "null_resource" "nrn_patch" {
  depends_on = [nullplatform_service_specification.from_template]

  triggers = {
    nrn          = var.nrn
    service_slug = local.service_slug
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