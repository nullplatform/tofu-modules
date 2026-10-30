################################################################################
# Installation of a published scope package
#
# The package brings the scope specification and its action specifications,
# read-only. A scope also needs pieces that belong to each organization, and
# this module creates them from the templates of the scope repository checkout
# it is given (var.local_specs_path), the same tag the package was published
# from:
#   1. the installation of the package at var.nrn;
#   2. the scope type pointing at the package's specification;
#   3. the NRN settings that pick the scope's metrics and logs providers;
#   4. optionally, the scope-configuration provider specification (its schema);
#   5. optionally, the agent channel routing the scope's actions to the package
#      worker. Organizations that keep channels in a separate bindings layer
#      turn it off and create it there with scope_definition_agent_association,
#      the same as for a scope they register themselves.
# The scope's cloud permissions are not here: each scope repository creates
# them with its own requirements module, next to this one.
################################################################################

# 1. Installation
module "installation" {
  source = "../package_installation"

  nrn             = var.nrn
  package_slug    = var.package_slug
  package_version = var.package_version
  visible_to      = var.visible_to
}

# 2. Scope type, rendered from the repository's template like scope_definition does
data "external" "scope_type" {
  program = ["sh", "-c", <<-EOT
    template_b64="${base64encode(file("${var.local_specs_path}/specs/scope-type-definition.json.tpl"))}"
    processed_json=$(echo "$template_b64" | base64 -d | \
    NRN='${var.nrn}' \
    SERVICE_SPECIFICATION_ID='${local.specification_id}' \
    gomplate)
    printf '%s\n' "$processed_json" | jq -c '{json: tojson}'
  EOT
  ]
}

resource "nullplatform_scope_type" "this" {
  nrn           = var.nrn
  name          = coalesce(var.scope_type_name, local.scope_type_template.name)
  description   = local.scope_type_template.description
  provider_type = local.scope_type_template.provider_type
  provider_id   = local.specification_id

  lifecycle {
    precondition {
      condition     = length(module.installation.service_specification_ids) == 1
      error_message = "A scope package pins exactly one service specification; ${var.package_slug} ${var.package_version} pins ${length(module.installation.service_specification_ids)}."
    }
  }
}

# 3. NRN settings: which providers serve this scope's metrics and logs. No
#    provider resource writes NRN settings, so this is the same `np nrn patch`
#    scope_definition runs.
resource "terraform_data" "nrn_settings" {
  triggers_replace = {
    nrn              = var.nrn
    slug             = local.specification_slug
    metrics_provider = var.external_metrics_provider
    logging_provider = var.external_logging_provider
  }

  provisioner "local-exec" {
    command = <<-EOT
      np nrn patch --nrn "${var.nrn}" --body '{
        "global.${local.specification_slug}_metric_provider": "${var.external_metrics_provider}",
        "global.${local.specification_slug}_log_provider": "${var.external_logging_provider}"
      }'
    EOT

    environment = var.np_api_key == null ? {} : { NP_API_KEY = var.np_api_key }
  }
}

# 4. Scope-configuration schema. Provider specifications are not package
#    components, so each organization gets its own, from the same template.
resource "nullplatform_provider_specification" "scope_configuration" {
  count = var.create_scope_configuration ? 1 : 0

  name             = coalesce(var.scope_configuration_name, local.scope_configuration.name)
  icon             = local.scope_configuration.icon
  description      = local.scope_configuration.description
  category         = local.scope_configuration.category
  allow_dimensions = local.scope_configuration.allow_dimensions
  visible_to       = [var.nrn]
  schema           = jsonencode(local.scope_configuration.schema)
}

# 5. Agent channel: package-exec to the package worker.
module "agent_channel" {
  source = "../scope_definition_agent_association"
  count  = var.create_agent_channel ? 1 : 0

  nrn         = var.nrn
  description = coalesce(var.channel_description, "${var.package_slug} package worker")

  scope_specification_id   = local.specification_id
  scope_specification_slug = local.specification_slug

  local_specs_path = var.local_specs_path
  service_path     = var.service_path

  worker_orchestrator = true
  package_slug        = var.package_slug
  entrypoint          = var.entrypoint

  tags_selectors = var.agent_tags_selectors

  depends_on = [nullplatform_scope_type.this]
}
