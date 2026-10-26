# Module: scope_package_installation

## Description

Installs a scope package published by another organization and creates, from the scope repository's own templates, the pieces each organization owns: the scope type, the NRN settings for metrics and logs, the optional scope-configuration schema and the agent channel. Scope repositories call it from their `installation/` module, next to their own cloud requirements.

## Architecture

The package brings the scope specification and its action specifications, read-only. On top of [`package_installation`](../package_installation), this module:

1. Finds the package's specification in the installed revision's bill of materials (exactly one is expected) and reads its slug once the installation makes it visible at `nrn`.
2. Renders `specs/scope-type-definition.json.tpl` with gomplate, as `scope_definition` does, and creates a `nullplatform_scope_type` pointing at that specification.
3. Writes the NRN settings that pick the scope's metrics and logs providers with `np nrn patch`, the same command `scope_definition` runs (no provider resource writes NRN settings).
4. With `create_scope_configuration`, creates the scope-configuration provider specification from `specs/scope-configuration.json.tpl`. Provider specifications are not package components, so each organization gets its own.
5. Creates the `package-exec` agent channel with [`scope_definition_agent_association`](../scope_definition_agent_association), from `specs/notification-channel.json.tpl`.

Every template is read from `local_specs_path`: the scope repository's installation module passes its own directory, so the per-organization pieces come from the same tag as the package. Nothing is fetched over HTTP, which also works for private repositories.

The specification is read with a reference to the installation's ID instead of a `depends_on`. The ID is unknown only while the installation is being created, so a later plan (an upgrade) reads the specification at plan time and does not turn the scope type and the channel into unknown values.

Cloud permissions are deliberately out of this module: each scope repository creates them with its own requirements module.

## Features

- Installs the scope package at the version of the tag the caller references
- Points a new scope type at the package's specification, which the organization does not own
- Writes the scope's metrics and logs providers to the NRN settings
- Creates the scope-configuration schema from the repository's template, with an optional name override for collisions
- Creates the `package-exec` agent channel from the repository's channel template
- Refuses packages that do not pin exactly one specification
- Reads every template from the repository checkout, never over HTTP

Requires `gomplate`, `jq` and `np` on the machine running the apply.

## Basic Usage

A scope repository's `installation/main.tf`, referenced by its users at a release tag:

```hcl
module "requirements" {
  source = "../specs/requirements"
  # ...
}

module "package" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_package_installation?ref=v9.5.0"

  nrn                        = var.nrn
  package_slug               = "my-scope"
  package_version            = local.version
  local_specs_path           = abspath("${path.module}/..")
  service_path               = "my-scope"
  agent_tags_selectors       = var.agent_tags_selectors
  np_api_key                 = var.np_api_key
  create_scope_configuration = true
}
```

## Using Outputs

```hcl
# The scope's settings, in a provider of the schema the module created
resource "nullplatform_provider_config" "scope_configuration" {
  nrn        = "organization=123:account=456"
  type       = module.package.scope_configuration_specification_slug
  attributes = jsonencode({ state_bucket = "my-state-bucket" })
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.5 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.110 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.3.5 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.110 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_agent_channel"></a> [agent\_channel](#module\_agent\_channel) | ../scope_definition_agent_association | n/a |
| <a name="module_installation"></a> [installation](#module\_installation) | ../package_installation | n/a |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_specification.scope_configuration](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_specification) | resource |
| [nullplatform_scope_type.this](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/scope_type) | resource |
| [terraform_data.nrn_settings](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_tags_selectors"></a> [agent\_tags\_selectors](#input\_agent\_tags\_selectors) | Tags that select the agent running the package worker (must match the agent's TAGS), e.g. { cluster = "runtime" }. | `map(string)` | n/a | yes |
| <a name="input_channel_description"></a> [channel\_description](#input\_channel\_description) | Description of the agent channel. Null uses "<package\_slug> package worker". | `string` | `null` | no |
| <a name="input_create_scope_configuration"></a> [create\_scope\_configuration](#input\_create\_scope\_configuration) | Create the scope-configuration provider specification from specs/scope-configuration.json.tpl. Set it to true only when the scope ships that file. | `bool` | `false` | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | Command the channel sends to the worker. Empty uses the module default (/app/packages/<package\_slug>/entrypoint). worker-bridge images ignore it and run their baked NP\_SCOPE\_ENTRYPOINT. | `string` | `""` | no |
| <a name="input_external_logging_provider"></a> [external\_logging\_provider](#input\_external\_logging\_provider) | Logs provider recorded in the NRN settings for this scope. | `string` | `"external"` | no |
| <a name="input_external_metrics_provider"></a> [external\_metrics\_provider](#input\_external\_metrics\_provider) | Metrics provider recorded in the NRN settings for this scope. | `string` | `"externalmetrics"` | no |
| <a name="input_local_specs_path"></a> [local\_specs\_path](#input\_local\_specs\_path) | Absolute path to the scope's directory in a checkout of its repository: the<br/>one holding `specs/scope-type-definition.json.tpl`,<br/>`specs/notification-channel.json.tpl` and, with create\_scope\_configuration,<br/>`specs/scope-configuration.json.tpl`. A scope repository's installation<br/>module passes its own directory (`abspath("${path.module}/..")`), so the<br/>per-organization pieces come from the same tag as the package. | `string` | n/a | yes |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | nullplatform API key for the `np nrn patch` that sets the scope's metrics and logs providers. Null uses the NP\_API\_KEY of the environment running the apply. | `string` | `null` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN of the installing organization where the scope is installed (e.g. organization=123:account=456). The package is looked up as visible there, and the installation, scope type, NRN settings, scope-configuration schema and agent channel are created there. | `string` | n/a | yes |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Slug of the scope package to install. | `string` | n/a | yes |
| <a name="input_package_version"></a> [package\_version](#input\_package\_version) | Exact semver of the package revision to install (X.Y.Z, without a leading v). Scope repositories pass the version of the tag their installation module is referenced at. | `string` | n/a | yes |
| <a name="input_scope_configuration_name"></a> [scope\_configuration\_name](#input\_scope\_configuration\_name) | Name of the scope-configuration provider specification. Null uses the template's; override it when that name collides with one already visible in the organization. | `string` | `null` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path of the scope inside its repository (e.g. "lambda"), exported as SERVICE\_PATH to the channel template. | `string` | n/a | yes |
| <a name="input_visible_to"></a> [visible\_to](#input\_visible\_to) | Where inside the installing organization the scope can be used. Null uses [nrn]. Every entry must be under the installing organization. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_installation_id"></a> [installation\_id](#output\_installation\_id) | ID of the package installation. |
| <a name="output_installed_version"></a> [installed\_version](#output\_installed\_version) | Version new scopes are born with. |
| <a name="output_missing_optional_requirements"></a> [missing\_optional\_requirements](#output\_missing\_optional\_requirements) | Optional providers the package can use that were not configured at nrn or above it when it was installed. |
| <a name="output_notification_channel_id"></a> [notification\_channel\_id](#output\_notification\_channel\_id) | ID of the agent notification channel. |
| <a name="output_scope_configuration_specification_id"></a> [scope\_configuration\_specification\_id](#output\_scope\_configuration\_specification\_id) | ID of the scope-configuration provider specification, or null without create\_scope\_configuration. |
| <a name="output_scope_configuration_specification_slug"></a> [scope\_configuration\_specification\_slug](#output\_scope\_configuration\_specification\_slug) | Slug of the scope-configuration provider specification: the `type` of the provider config that holds the scope's settings. Null without create\_scope\_configuration. |
| <a name="output_scope_type_id"></a> [scope\_type\_id](#output\_scope\_type\_id) | ID of the scope type created in the organization. |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | ID of the package's scope specification, the one the scope type points at. |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | Slug of the package's scope specification. |
<!-- END_TF_DOCS -->
