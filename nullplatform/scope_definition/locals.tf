locals {
  # Templates come from var.local_specs_path when set (a checkout of the scope
  # repository, e.g. the one a release is published from), or over HTTP.
  reads_local_specs = var.local_specs_path != null

  service_spec_template = local.reads_local_specs ? file("${var.local_specs_path}/specs/service-spec.json.tpl") : data.http.service_spec_template[0].response_body
  scope_type_template   = local.reads_local_specs ? file("${var.local_specs_path}/specs/scope-type-definition.json.tpl") : data.http.scope_type_template[0].response_body
  action_templates = {
    for name in local.static_action_specs :
    name => local.reads_local_specs ? file("${var.local_specs_path}/specs/actions/${name}.json.tpl") : data.http.action_templates[name].response_body
  }
  scope_configuration_template = !var.create_scope_configuration ? null : (
    local.reads_local_specs ? file("${var.local_specs_path}/specs/scope-configuration.json.tpl") : data.http.scope_configuration_template[0].response_body
  )

  service_spec_parsed = jsondecode(data.external.service_spec.result.json)

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

  # Extra `KEY='value' ` shell assignments for every gomplate render. Keys and
  # values are validated on var.template_env_vars (shell-safe). Empty by default.
  template_env_assignments = join("", [for k in sort(keys(var.template_env_vars)) : "${k}='${var.template_env_vars[k]}' "])

  scope_type_def = jsondecode(data.external.scope_type.result.json)

  static_action_specs = toset(
    var.action_spec_names != null ? var.action_spec_names : try(local.service_spec_parsed.available_actions, [])
  )

  # Not gomplate: each quoted `"{{ env.Getenv ... }}"` string becomes the NRN
  # (greedy `.*`: one placeholder per line), so template_env_vars do not apply.
  scope_configuration_rendered = var.create_scope_configuration ? replace(
    local.scope_configuration_template,
    "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
    "\"${var.nrn}\""
  ) : "{}"
  scope_configuration = var.create_scope_configuration ? jsondecode(local.scope_configuration_rendered) : null
}
