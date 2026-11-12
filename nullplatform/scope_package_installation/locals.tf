locals {
  # The precondition on nullplatform_scope_type.this reports a package that does
  # not pin exactly one specification. Until it does, this is empty rather than
  # null or an error, so the plan reaches that precondition.
  specification_id   = module.installation.service_specification_id != null ? module.installation.service_specification_id : ""
  specification_slug = module.installation.service_specification_slug

  # The scope-configuration template, from the checkout or over HTTP. Only the
  # taken branch is evaluated, so no file is read and nothing is fetched when
  # the schema is not created.
  scope_configuration_template = !var.create_scope_configuration ? null : (
    var.local_specs_path != null
    ? file("${var.local_specs_path}/specs/scope-configuration.json.tpl")
    : data.http.scope_configuration_template[0].response_body
  )

  # Not gomplate, same as scope_definition: each quoted `"{{ env.Getenv ... }}"`
  # string becomes the NRN (greedy `.*`: one placeholder per line).
  scope_configuration = var.create_scope_configuration ? jsondecode(replace(
    local.scope_configuration_template,
    "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
    "\"${var.nrn}\""
  )) : null
}
