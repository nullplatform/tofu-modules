locals {
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

  static_action_specs = toset(var.action_spec_names)

  scope_configuration_rendered = var.create_scope_configuration ? replace(
    data.http.scope_configuration_template[0].response_body,
    "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
    "\"${var.organization_nrn}\""
  ) : "{}"
  scope_configuration = var.create_scope_configuration ? jsondecode(local.scope_configuration_rendered) : null
}
