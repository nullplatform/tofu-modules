locals {
  # Cuerpo de cada template, venga de HTTP o del disco. El resto del módulo
  # consume estos locales y no le importa el origen: el pipeline de gomplate
  # que procesa los placeholders es el mismo en los dos modos.
  service_spec_template_body = var.git_provider == "local" ? (
    file("${var.local_specs_path}/specs/service-spec.json.tpl")
  ) : data.http.service_spec_template[0].response_body

  scope_type_template_body = var.git_provider == "local" ? (
    file("${var.local_specs_path}/specs/scope-type-definition.json.tpl")
  ) : data.http.scope_type_template[0].response_body

  action_template_bodies = var.git_provider == "local" ? {
    for name in local.static_action_specs :
    name => file("${var.local_specs_path}/specs/actions/${name}.json.tpl")
    } : {
    for name, d in data.http.action_templates : name => d.response_body
  }

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

  scope_type_def = jsondecode(data.external.scope_type.result.json)

  static_action_specs = toset(
    var.action_spec_names != null ? var.action_spec_names : try(local.service_spec_parsed.available_actions, [])
  )

  scope_configuration_rendered = var.create_scope_configuration ? replace(
    (var.git_provider == "local"
      ? file("${var.local_specs_path}/specs/scope-configuration.json.tpl")
    : data.http.scope_configuration_template[0].response_body),
    "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
    "\"${var.nrn}\""
  ) : "{}"
  scope_configuration = var.create_scope_configuration ? jsondecode(local.scope_configuration_rendered) : null
}
