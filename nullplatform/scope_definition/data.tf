################################################################################
# Template Fetching
################################################################################
data "http" "service_spec_template" {
  url = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads/main/${var.service_path}/specs/service-spec.json.tpl"
}

data "http" "scope_type_template" {
  url = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads/main/${var.service_path}/specs/scope-type-definition.json.tpl"
}

data "http" "action_templates" {
  for_each = toset(var.action_spec_names)
  url      = "https://raw.githubusercontent.com/nullplatform/scopes/refs/heads/main/${var.service_path}/specs/actions/${each.key}.json.tpl"
}

# Process service specification template using gomplate with NRN variable
data "external" "service_spec" {
  depends_on = [data.http.service_spec_template]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(data.http.service_spec_template.response_body)}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${var.nrn}' \
    gomplate)
    echo "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}

# Process scope type template with service specification context
data "external" "scope_type" {
  depends_on = [
    nullplatform_service_specification.from_template,
    data.http.scope_type_template
  ]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(data.http.scope_type_template.response_body)}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${local.dependent_env_vars.NRN}' \
    SERVICE_SPECIFICATION_ID='${local.dependent_env_vars.SERVICE_SPECIFICATION_ID}' \
    gomplate)
    echo "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}

# Process all action specification templates with full service context
data "external" "action_specs" {
  for_each = toset(var.action_spec_names)
  depends_on = [
    nullplatform_service_specification.from_template,
    data.http.action_templates
  ]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(try(data.http.action_templates[each.key].response_body, "{}"))}"
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