################################################################################
# Template Fetching
#
# A non-2xx is not an error for the http provider: without these postconditions
# a missing template's body (`404: Not Found`) renders as the template and dies
# later in jq. Branch defaults track a moving ref, so an upstream rename can
# break an already-applied state.
################################################################################
data "http" "service_spec_template" {
  url = "${var.repository_service_spec}/${var.repository_service_spec_branch}/${var.service_path}/specs/service-spec.json.tpl"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Fetch of ${self.url} returned HTTP ${self.status_code}, expected 200."
    }
  }
}

data "http" "scope_type_template" {
  url = "${var.repository_scope_template}/${var.repository_scope_template_branch}/${var.service_path}/specs/scope-type-definition.json.tpl"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Fetch of ${self.url} returned HTTP ${self.status_code}, expected 200."
    }
  }
}

data "http" "action_templates" {
  for_each = local.static_action_specs
  url      = "${var.repository_action_templates}/${var.repository_action_templates_branch}/${var.service_path}/specs/actions/${each.key}.json.tpl"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Fetch of ${self.url} returned HTTP ${self.status_code}, expected 200. Check that the action name is spelled as the template file in the scope repository."
    }
  }
}

data "http" "scope_configuration_template" {
  count = var.create_scope_configuration ? 1 : 0
  url   = "${var.repository_scope_template}/${var.repository_scope_template_branch}/${var.service_path}/specs/scope-configuration.json.tpl"

  lifecycle {
    postcondition {
      condition     = self.status_code == 200
      error_message = "Fetch of ${self.url} returned HTTP ${self.status_code}, expected 200."
    }
  }
}

# Process service specification template using gomplate with NRN variable
data "external" "service_spec" {
  depends_on = [data.http.service_spec_template]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(data.http.service_spec_template.response_body)}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${var.nrn}' \
    gomplate)
    printf '%s\n' "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}

# Process scope type template with service specification context
# `depends_on` deliberately does NOT list `nullplatform_service_specification`:
# the implicit reference to its `.id` via SERVICE_SPECIFICATION_ID already
# creates that edge. An explicit whole-resource depends_on here defers this
# entire data source to apply-time whenever service_specification has ANY
# pending change, marking provider_type unknown and forcing a phantom
# destroy+recreate of scope_type (provider_type is ForceNew). Confirmed by
# forcing a drift on service_specification with/without this depends_on.
data "external" "scope_type" {
  depends_on = [
    data.http.scope_type_template
  ]

  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(data.http.scope_type_template.response_body)}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${local.dependent_env_vars.NRN}' \
    SERVICE_SPECIFICATION_ID='${local.dependent_env_vars.SERVICE_SPECIFICATION_ID}' \
    gomplate)
    printf '%s\n' "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}

# Process all action specification templates with full service context
# `depends_on` deliberately does NOT list `nullplatform_service_specification`
# — see the comment on `data.external.scope_type` above. Same cascade, but
# it forces a phantom destroy+recreate of EVERY action_specification
# instance at once (their `type` is ForceNew).
data "external" "action_specs" {
  for_each = local.static_action_specs
  depends_on = [
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
    printf '%s\n' "$processed_json" | jq -c '{json_b64: (tojson | @base64)}'
  EOT
  ]
}
