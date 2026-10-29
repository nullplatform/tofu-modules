locals {
  # The precondition on data.nullplatform_service_specification.this reports a
  # package that does not pin exactly one specification. Until it does, this is
  # empty rather than null or an error, so the plan reaches that precondition.
  specification_id   = try(one(module.installation.service_specification_ids), "")
  specification_slug = data.nullplatform_service_specification.this.slug

  scope_type_template = jsondecode(data.external.scope_type.result.json)

  # Not gomplate, same as scope_definition: each quoted `"{{ env.Getenv ... }}"`
  # string becomes the NRN (greedy `.*`: one placeholder per line).
  scope_configuration = var.create_scope_configuration ? jsondecode(replace(
    file("${var.local_specs_path}/specs/scope-configuration.json.tpl"),
    "/\"{{\\s+env.Getenv\\s+\".*\"\\s+}}\"/",
    "\"${var.nrn}\""
  )) : null
}
