# Module: scope_package_installation

## Description

Installs a nullplatform scope package into an organization by creating the package installation, scope type, NRN settings, optional scope-configuration provider specification, and agent channel from repository-local templates

## Architecture

The module chains a `package_installation` child module to register the package at the given NRN, then reads the resulting `nullplatform_service_specification` data source to obtain the specification ID and slug. A `data.external` resource renders the scope-type template via gomplate and feeds the output into a `nullplatform_scope_type` resource, while a `terraform_data` resource runs `np nrn patch` as a local-exec provisioner to write metrics and logging provider settings. Optionally a `nullplatform_provider_specification` resource is created from a local JSON template, and a `scope_definition_agent_association` child module wires the agent channel to the scope specification and package worker.

## Features

- Installs a versioned scope package via the package_installation child module and reads its service specification
- Creates a nullplatform_scope_type resource rendered from a gomplate scope-type-definition template in the local repository checkout
- Configures NRN-level metrics and logging provider settings via a terraform_data local-exec provisioner running np nrn patch
- Optionally creates a nullplatform_provider_specification for scope-configuration from a local JSON template when create_scope_configuration is enabled
- Wires an agent notification channel to the package worker via the scope_definition_agent_association child module with configurable tag selectors
- Supports overriding scope type name and scope-configuration specification name to avoid collisions with existing organization resources
- Exposes installation ID, specification ID and slug, scope type ID, scope-configuration specification details, and channel ID as outputs

## Basic Usage

```hcl
module "scope_package_installation" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_package_installation?ref=v9.7.0"

  agent_tags_selectors = "your-agent-tags-selectors"
  local_specs_path     = "your-local-specs-path"
  nrn                  = "your-nrn"
  package_slug         = "your-package-slug"
  package_version      = "your-package-version"
  service_path         = "your-service-path"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.scope_package_installation.installation_id
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
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.110 |
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
| <a name="input_scope_type_name"></a> [scope\_type\_name](#input\_scope\_type\_name) | Name of the scope type. Null uses the template's; override it when that name collides with a scope type already in the organization, such as one registered with scope\_definition. | `string` | `null` | no |
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

<!-- BEGIN_AI_METADATA
{
  "name": "scope_package_installation",
  "description": "Installs a nullplatform scope package into an organization by creating the package installation, scope type, NRN settings, optional scope-configuration provider specification, and agent channel from repository-local templates",
  "architecture": "The module chains a `package_installation` child module to register the package at the given NRN, then reads the resulting `nullplatform_service_specification` data source to obtain the specification ID and slug. A `data.external` resource renders the scope-type template via gomplate and feeds the output into a `nullplatform_scope_type` resource, while a `terraform_data` resource runs `np nrn patch` as a local-exec provisioner to write metrics and logging provider settings. Optionally a `nullplatform_provider_specification` resource is created from a local JSON template, and a `scope_definition_agent_association` child module wires the agent channel to the scope specification and package worker.",
  "features": [
    "Installs a versioned scope package via the package_installation child module and reads its service specification",
    "Creates a nullplatform_scope_type resource rendered from a gomplate scope-type-definition template in the local repository checkout",
    "Configures NRN-level metrics and logging provider settings via a terraform_data local-exec provisioner running np nrn patch",
    "Optionally creates a nullplatform_provider_specification for scope-configuration from a local JSON template when create_scope_configuration is enabled",
    "Wires an agent notification channel to the package worker via the scope_definition_agent_association child module with configurable tag selectors",
    "Supports overriding scope type name and scope-configuration specification name to avoid collisions with existing organization resources",
    "Exposes installation ID, specification ID and slug, scope type ID, scope-configuration specification details, and channel ID as outputs"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "NRN of the installing organization where the scope is installed (e.g. organization=123:account=456). The package is looked up as visible there, and the installation, scope type, NRN settings, scope-configuration schema and agent channel are created there.",
      "required": true
    },
    {
      "name": "package_slug",
      "description": "Slug of the scope package to install.",
      "required": true
    },
    {
      "name": "package_version",
      "description": "Exact semver of the package revision to install (X.Y.Z, without a leading v). Scope repositories pass the version of the tag their installation module is referenced at.",
      "required": true
    },
    {
      "name": "local_specs_path",
      "description": "",
      "required": true
    },
    {
      "name": "service_path",
      "description": "Path of the scope inside its repository (e.g. \\",
      "required": true
    },
    {
      "name": "agent_tags_selectors",
      "description": "Tags that select the agent running the package worker (must match the agent's TAGS), e.g. { cluster = \\",
      "required": true
    },
    {
      "name": "visible_to",
      "description": "Where inside the installing organization the scope can be used. Null uses [nrn]. Every entry must be under the installing organization.",
      "required": false
    },
    {
      "name": "np_api_key",
      "description": "nullplatform API key for the `np nrn patch` that sets the scope's metrics and logs providers. Null uses the NP_API_KEY of the environment running the apply.",
      "required": false
    },
    {
      "name": "external_metrics_provider",
      "description": "Metrics provider recorded in the NRN settings for this scope.",
      "required": false
    },
    {
      "name": "external_logging_provider",
      "description": "Logs provider recorded in the NRN settings for this scope.",
      "required": false
    },
    {
      "name": "scope_type_name",
      "description": "Name of the scope type. Null uses the template's; override it when that name collides with a scope type already in the organization, such as one registered with scope_definition.",
      "required": false
    },
    {
      "name": "create_scope_configuration",
      "description": "Create the scope-configuration provider specification from specs/scope-configuration.json.tpl. Set it to true only when the scope ships that file.",
      "required": false
    },
    {
      "name": "scope_configuration_name",
      "description": "Name of the scope-configuration provider specification. Null uses the template's; override it when that name collides with one already visible in the organization.",
      "required": false
    },
    {
      "name": "channel_description",
      "description": "Description of the agent channel. Null uses \\",
      "required": false
    },
    {
      "name": "entrypoint",
      "description": "Command the channel sends to the worker. Empty uses the module default (/app/packages/<package_slug>/entrypoint). worker-bridge images ignore it and run their baked NP_SCOPE_ENTRYPOINT.",
      "required": false
    }
  ],
  "outputs": [
    "installation_id",
    "installed_version",
    "missing_optional_requirements",
    "service_specification_id",
    "service_specification_slug",
    "scope_type_id",
    "scope_configuration_specification_id",
    "scope_configuration_specification_slug",
    "notification_channel_id"
  ],
  "hash": "44027f7edf81f86b217b36d3c8821d3f"
}
END_AI_METADATA -->
