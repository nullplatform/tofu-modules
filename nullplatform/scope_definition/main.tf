################################################################################
# Git Repository Clone
################################################################################

# Clone the repository once and use local files
resource "null_resource" "clone_repo" {
  triggers = {
    repo_url = var.github_repo_url
    ref      = var.github_ref
  }

  provisioner "local-exec" {
    command = <<-EOT
      rm -rf ${path.root}/.terraform-repo
      git clone --depth 1 --branch ${var.github_ref} ${var.github_repo_url} ${path.root}/.terraform-repo
    EOT
  }
}

################################################################################
# Template Fetching (from local git clone)
################################################################################

# Read service specification template from local clone
data "local_file" "service_spec_template" {
  depends_on = [null_resource.clone_repo]
  filename   = "${path.root}/.terraform-repo/${var.service_path}/specs/service-spec.json.tpl"
}

# Read scope type definition template from local clone
data "local_file" "scope_type_template" {
  depends_on = [null_resource.clone_repo]
  filename   = "${path.root}/.terraform-repo/${var.service_path}/specs/scope-type-definition.json.tpl"
}

# Read all action specification templates from local clone
data "local_file" "action_templates" {
  for_each   = toset(var.action_spec_names)
  depends_on = [null_resource.clone_repo]
  filename   = "${path.root}/.terraform-repo/${var.service_path}/specs/actions/${each.key}.json.tpl"
}

################################################################################
# Service Specification
################################################################################

# Process service specification template using gomplate with NRN variable
data "external" "service_spec" {
  depends_on = [data.local_file.service_spec_template]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(data.local_file.service_spec_template.content)}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${var.nrn}' \
    gomplate)
    echo "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}

locals {
  service_spec_parsed = jsondecode(data.external.service_spec.result.json)
}

# Create service specification resource from processed template
resource "nullplatform_service_specification" "from_template" {
  depends_on = [
    data.external.action_specs
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
  depends_on = [
    nullplatform_service_specification.from_template,
    data.local_file.scope_type_template
  ]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(data.local_file.scope_type_template.content)}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${local.dependent_env_vars.NRN}' \
    SERVICE_SPECIFICATION_ID='${local.dependent_env_vars.SERVICE_SPECIFICATION_ID}' \
    gomplate)
    echo "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}

locals {
  scope_type_def = jsondecode(data.external.scope_type.result.json)
}

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

# Process all action specification templates with full service context
data "external" "action_specs" {
  for_each = toset(var.action_spec_names)
  depends_on = [
    nullplatform_service_specification.from_template,
    data.local_file.action_templates
  ]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(try(data.local_file.action_templates[each.key].content, "{}"))}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${local.dependent_env_vars.NRN}' \
    SERVICE_SPECIFICATION_ID='${local.dependent_env_vars.SERVICE_SPECIFICATION_ID}' \
    SERVICE_SLUG='${local.dependent_env_vars.SERVICE_SLUG}' \
    SERVICE_PATH='${local.dependent_env_vars.SERVICE_PATH}' \
    REPO_PATH='${local.dependent_env_vars.REPO_PATH}' \
    gomplate)
    echo "$processed_json" | jq -c '{json_b64: (tojson | @base64)}'
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
    metrics_provider = var.metrics_provider
    logging_provider = var.logging_provider
  }

  provisioner "local-exec" {
    command = <<-EOT
      np nrn patch --nrn "${var.nrn}" --body "{
        \"global.${local.service_slug}_metric_provider\": \"${var.metrics_provider}\",
        \"global.${local.service_slug}_log_provider\": \"${var.logging_provider}\"
      }"
    EOT

    environment = {
      NP_API_KEY = var.np_api_key
    }
  }
}

################################################################################
# Cleanup
################################################################################

# Optional: Clean up cloned repo after apply
resource "null_resource" "cleanup_repo" {
  depends_on = [
    nullplatform_service_specification.from_template,
    nullplatform_scope_type.from_template,
    nullplatform_action_specification.from_templates
  ]

  provisioner "local-exec" {
    when    = destroy
    command = "rm -rf ${path.root}/.terraform-repo"
  }
}
