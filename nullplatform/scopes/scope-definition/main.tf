################################################################################
# Step 1: Fetch Templates
################################################################################

locals {
 git_login = var.git_user != null && var.git_password !=null ? "${var.git_user}:${var.git_password}@" : var.git_user != null ? "${var.git_user}@" : ""
 full_git_repo_url = var.git_provider == "github" ? "https://${local.git_login}raw.githubusercontent.com/${var.git_repo}/refs/heads/${var.git_ref}" : null
}

# Fetch service specification template
data "http" "service_spec_template" {
  url = "${local.full_git_repo_url}/${var.git_scope_path}/specs/service-spec.json${var.use_tpl_files ? ".tpl" : ""}"
}
# Fetch action specification templates
data "http" "action_templates" {
  for_each = toset(local.available_actions)
  url      = "${local.full_git_repo_url}/${var.git_scope_path}/specs/actions/${each.key}.json${var.use_tpl_files ? ".tpl" : ""}"
}



################################################################################
# Step 2: Process and Create Service Specification
################################################################################

locals {
    # Process the template by replacing the template variables
    # replace is done because some old templates contain gomplate placeholders
    service_spec_rendered = var.use_tpl_files ? replace(
        data.http.service_spec_template.response_body,
        "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
        "\"\""
    ) : data.http.service_spec_template.response_body
    service_spec_parsed = jsondecode(local.service_spec_rendered)
    available_actions = local.service_spec_parsed.available_actions
}

# Create service specification
resource "nullplatform_service_specification" "from_template" {
  name                = local.service_spec_parsed.name
  visible_to          = [var.nrn]
  type               = local.service_spec_parsed.type
  attributes         = jsonencode(local.service_spec_parsed.attributes)
  use_default_actions = local.service_spec_parsed.use_default_actions

  selectors {
    category     = local.service_spec_parsed.selectors.category
    imported     = local.service_spec_parsed.selectors.imported
    provider     = local.service_spec_parsed.selectors.provider
    sub_category = local.service_spec_parsed.selectors.sub_category
  }
}

locals {
  # Variables that depend on created service specification
  service_specification_id = nullplatform_service_specification.from_template.id
  service_slug             = nullplatform_service_specification.from_template.slug

  dependent_env_vars = {
    NRN                      = var.nrn
    SERVICE_SPECIFICATION_ID = local.service_specification_id
    SERVICE_SLUG             = local.service_slug
  }
}

################################################################################
# Step 3: Process and Create Scope Type
################################################################################



# Create scope type
resource "nullplatform_scope_type" "from_template" {
  depends_on = [nullplatform_service_specification.from_template]

  nrn         = var.nrn
  name        = var.scope_name
  description = var.scope_description
  provider_id = local.service_specification_id
}

################################################################################
# Step 4: Create Action Specifications
################################################################################

# Process action templates - conditional processing based on file type
# replace is done because some old templates contain gomplate placeholders
locals {
  action_specs_parsed = {
    for name in local.available_actions :
    name => jsondecode(var.use_tpl_files ? replace(
        data.http.action_templates[name].response_body,
        "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
        "\"\""
    ) : data.http.action_templates[name].response_body)
  }
}

# Create action specifications
resource "nullplatform_action_specification" "from_templates" {
  for_each   = toset(local.available_actions )
  depends_on = [nullplatform_service_specification.from_template]

  service_specification_id = local.service_specification_id
  name                     = local.action_specs_parsed[each.key].name
  type                     = local.action_specs_parsed[each.key].type
  parameters               = jsonencode(local.action_specs_parsed[each.key].parameters)
  results                  = jsonencode(local.action_specs_parsed[each.key].results)
  retryable                = try(local.action_specs_parsed[each.key].retryable, false)
}

## TODO: Change by NRN API when available or provider
resource "null_resource" "nrn_patch" {
  depends_on = [nullplatform_service_specification.from_template]

  triggers = {
    nrn          = var.nrn
    service_slug = local.service_slug
  }

  provisioner "local-exec" {
    command = <<-EOT
      np nrn patch --nrn "${var.nrn}" --body "{
        \"global.${local.service_slug}_metric_provider\": \"${var.metrics_provider}\",
        \"global.${local.service_slug}_log_provider\": \"${var.logs_provider}\"
      }"
    EOT

    environment = {
      NP_API_KEY = var.np_api_key
    }
  }
}