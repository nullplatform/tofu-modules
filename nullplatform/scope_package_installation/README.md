# Module: scope_package_installation

## Description

Installs a published nullplatform scope package into an organization and creates the associated scope type, NRN settings, optional scope-configuration provider specification, and optional agent channel

## Architecture

The module composes a `package_installation` child module to register the package at the given NRN, then creates a `nullplatform_scope_type` resource wired to the installed specification ID resolved from that child module. A `terraform_data` resource runs a `np nrn patch` local-exec provisioner to write metrics and logging provider slugs into NRN settings. Optionally, a `nullplatform_provider_specification` resource is created from a JSON template read either from disk via `file()` or fetched via the `http` data source, and a `scope_definition_agent_association` child module creates the agent notification channel routing scope actions to the package worker.

## Features

- Installs a versioned scope package into a nullplatform organization via the package_installation child module
- Creates a nullplatform_scope_type resource linked to the package's service specification ID with a precondition enforcing exactly one pinned specification
- Writes scope metrics and logging provider slugs to NRN settings via a terraform_data local-exec provisioner running np nrn patch
- Optionally creates a nullplatform_provider_specification for the scope-configuration schema from a template fetched over HTTP or read from a local checkout
- Optionally creates an agent notification channel via the scope_definition_agent_association child module routing scope actions to the package worker
- Supports template retrieval from a local repository checkout or from a raw HTTP URL with a pinned ref for catalog-driven deployments
- Exposes compatibility-named outputs matching scope_definition so switching from a self-registered scope to a global package requires no downstream changes

## Basic Usage

```hcl
module "scope_package_installation" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_package_installation?ref=v9.8.0"

  nrn                      = "your-nrn"
  package_slug             = "your-package-slug"
  package_version          = "your-package-version"
  service_spec_description = "your-service-spec-description"
  service_spec_name        = "your-service-spec-name"
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
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.4 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.110 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | 3.6.3 |
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
| <a name="input_agent_tags_selectors"></a> [agent\_tags\_selectors](#input\_agent\_tags\_selectors) | Tags that select the agent running the package worker (must match the agent's TAGS), e.g. { cluster = "runtime" }. Required with create\_agent\_channel. | `map(string)` | `null` | no |
| <a name="input_channel_description"></a> [channel\_description](#input\_channel\_description) | Description of the agent channel. Null uses "<package\_slug> package worker". | `string` | `null` | no |
| <a name="input_create_agent_channel"></a> [create\_agent\_channel](#input\_create\_agent\_channel) | Create the agent channel that routes the scope's actions to the package worker. Turn it off when the organization creates its channels in a separate bindings layer with scope\_definition\_agent\_association. | `bool` | `true` | no |
| <a name="input_create_scope_configuration"></a> [create\_scope\_configuration](#input\_create\_scope\_configuration) | Create the scope-configuration provider specification from specs/scope-configuration.json.tpl. Set it to true only when the scope ships that file. | `bool` | `false` | no |
| <a name="input_entrypoint"></a> [entrypoint](#input\_entrypoint) | Command the channel sends to the worker. Empty uses the module default (/app/packages/<package\_slug>/entrypoint). worker-bridge images ignore it and run their baked NP\_SCOPE\_ENTRYPOINT. | `string` | `""` | no |
| <a name="input_external_logging_provider"></a> [external\_logging\_provider](#input\_external\_logging\_provider) | Logs provider recorded in the NRN settings for this scope. | `string` | `"external"` | no |
| <a name="input_external_metrics_provider"></a> [external\_metrics\_provider](#input\_external\_metrics\_provider) | Metrics provider recorded in the NRN settings for this scope. | `string` | `"externalmetrics"` | no |
| <a name="input_local_specs_path"></a> [local\_specs\_path](#input\_local\_specs\_path) | Absolute path to the scope's directory in a checkout of its repository: the<br/>one holding `specs/scope-configuration.json.tpl` and<br/>`specs/notification-channel.json.tpl`. When set, the templates are read from<br/>disk and `repository_scope_template(_branch)` are not used. A scope<br/>repository's installation module passes its own directory<br/>(`abspath("${path.module}/..")`). Null (the default) fetches the templates<br/>over HTTP. | `string` | `null` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | nullplatform API key for the `np nrn patch` that sets the scope's metrics and logs providers. Null uses the NP\_API\_KEY of the environment running the apply. | `string` | `null` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | NRN of the installing organization where the scope is installed (e.g. organization=123:account=456). The package is looked up as visible there, and the installation, scope type, NRN settings, scope-configuration schema and agent channel are created there. | `string` | n/a | yes |
| <a name="input_package_slug"></a> [package\_slug](#input\_package\_slug) | Slug of the scope package to install. | `string` | n/a | yes |
| <a name="input_package_version"></a> [package\_version](#input\_package\_version) | Exact semver of the package revision to install (X.Y.Z, without a leading v). New scopes are born with it; moving to another version is changing this value. | `string` | n/a | yes |
| <a name="input_repository_scope_template"></a> [repository\_scope\_template](#input\_repository\_scope\_template) | Base raw URL of the scope repository, up to the ref namespace, e.g.<br/>`https://raw.githubusercontent.com/nullplatform/scopes/refs/tags`. Same<br/>input as scope\_definition's. Required, together with<br/>`repository_scope_template_branch`, when a template is fetched over HTTP:<br/>`create_scope_configuration` or `create_agent_channel` without<br/>`local_specs_path`. | `string` | `null` | no |
| <a name="input_repository_scope_template_branch"></a> [repository\_scope\_template\_branch](#input\_repository\_scope\_template\_branch) | Ref the templates are fetched at, a tag or a branch name under `repository_scope_template`. Pin the tag the installed package version was published from, so the schema and the channel match the specification. | `string` | `null` | no |
| <a name="input_scope_configuration_name_override"></a> [scope\_configuration\_name\_override](#input\_scope\_configuration\_name\_override) | Name of the scope-configuration provider specification. Null uses the template's; override it when that name collides with one already visible in the organization. Same input as scope\_definition's. | `string` | `null` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path of the scope inside its repository (e.g. "lambda"). Part of the template URL, and exported as SERVICE\_PATH to the channel template. Required when a template is fetched over HTTP, and with create\_agent\_channel. | `string` | `null` | no |
| <a name="input_service_spec_description"></a> [service\_spec\_description](#input\_service\_spec\_description) | Description of the scope type. Same input as scope\_definition's. | `string` | n/a | yes |
| <a name="input_service_spec_name"></a> [service\_spec\_name](#input\_service\_spec\_name) | Name of the scope type developers pick when they create a scope. Same input as scope\_definition's. While a copy of the same scope registered with scope\_definition lives in the organization, pick a name that tells the two apart. | `string` | n/a | yes |
| <a name="input_visible_to"></a> [visible\_to](#input\_visible\_to) | Where inside the installing organization the scope can be used. Null uses [nrn]. Every entry must be under the installing organization. | `list(string)` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_installation_id"></a> [installation\_id](#output\_installation\_id) | ID of the package installation. |
| <a name="output_installed_version"></a> [installed\_version](#output\_installed\_version) | Version new scopes are born with. |
| <a name="output_missing_optional_requirements"></a> [missing\_optional\_requirements](#output\_missing\_optional\_requirements) | Optional providers the package can use that were not configured at nrn or above it when it was installed. |
| <a name="output_notification_channel_id"></a> [notification\_channel\_id](#output\_notification\_channel\_id) | ID of the agent notification channel, or null without create\_agent\_channel. |
| <a name="output_package_default_version"></a> [package\_default\_version](#output\_package\_default\_version) | Same as installed\_version: the version new scopes are born with. |
| <a name="output_package_id"></a> [package\_id](#output\_package\_id) | ID of the installed package. |
| <a name="output_provider_specification_slug"></a> [provider\_specification\_slug](#output\_provider\_specification\_slug) | Same as scope\_configuration\_specification\_slug. |
| <a name="output_scope_configuration_specification_id"></a> [scope\_configuration\_specification\_id](#output\_scope\_configuration\_specification\_id) | ID of the scope-configuration provider specification, or null without create\_scope\_configuration. |
| <a name="output_scope_configuration_specification_slug"></a> [scope\_configuration\_specification\_slug](#output\_scope\_configuration\_specification\_slug) | Slug of the scope-configuration provider specification: the `type` of the provider config that holds the scope's settings. Null without create\_scope\_configuration. |
| <a name="output_scope_type_id"></a> [scope\_type\_id](#output\_scope\_type\_id) | ID of the scope type created in the organization. |
| <a name="output_service_slug"></a> [service\_slug](#output\_service\_slug) | Same as service\_specification\_slug. |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | ID of the package's scope specification, the one the scope type points at. |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | Slug of the package's scope specification. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_package_installation",
  "description": "Installs a published nullplatform scope package into an organization and creates the associated scope type, NRN settings, optional scope-configuration provider specification, and optional agent channel",
  "architecture": "The module composes a `package_installation` child module to register the package at the given NRN, then creates a `nullplatform_scope_type` resource wired to the installed specification ID resolved from that child module. A `terraform_data` resource runs a `np nrn patch` local-exec provisioner to write metrics and logging provider slugs into NRN settings. Optionally, a `nullplatform_provider_specification` resource is created from a JSON template read either from disk via `file()` or fetched via the `http` data source, and a `scope_definition_agent_association` child module creates the agent notification channel routing scope actions to the package worker.",
  "features": [
    "Installs a versioned scope package into a nullplatform organization via the package_installation child module",
    "Creates a nullplatform_scope_type resource linked to the package's service specification ID with a precondition enforcing exactly one pinned specification",
    "Writes scope metrics and logging provider slugs to NRN settings via a terraform_data local-exec provisioner running np nrn patch",
    "Optionally creates a nullplatform_provider_specification for the scope-configuration schema from a template fetched over HTTP or read from a local checkout",
    "Optionally creates an agent notification channel via the scope_definition_agent_association child module routing scope actions to the package worker",
    "Supports template retrieval from a local repository checkout or from a raw HTTP URL with a pinned ref for catalog-driven deployments",
    "Exposes compatibility-named outputs matching scope_definition so switching from a self-registered scope to a global package requires no downstream changes"
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
      "description": "Exact semver of the package revision to install (X.Y.Z, without a leading v). New scopes are born with it; moving to another version is changing this value.",
      "required": true
    },
    {
      "name": "service_spec_name",
      "description": "Name of the scope type developers pick when they create a scope. Same input as scope_definition's. While a copy of the same scope registered with scope_definition lives in the organization, pick a name that tells the two apart.",
      "required": true
    },
    {
      "name": "service_spec_description",
      "description": "Description of the scope type. Same input as scope_definition's.",
      "required": true
    },
    {
      "name": "repository_scope_template",
      "description": "",
      "required": false
    },
    {
      "name": "service_path",
      "description": "Path of the scope inside its repository (e.g. \\",
      "required": false
    },
    {
      "name": "agent_tags_selectors",
      "description": "Tags that select the agent running the package worker (must match the agent's TAGS), e.g. { cluster = \\",
      "required": false
    },
    {
      "name": "visible_to",
      "description": "Where inside the installing organization the scope can be used. Null uses [nrn]. Every entry must be under the installing organization.",
      "required": false
    },
    {
      "name": "local_specs_path",
      "description": "",
      "required": false
    },
    {
      "name": "repository_scope_template_branch",
      "description": "Ref the templates are fetched at, a tag or a branch name under `repository_scope_template`. Pin the tag the installed package version was published from, so the schema and the channel match the specification.",
      "required": false
    },
    {
      "name": "create_scope_configuration",
      "description": "Create the scope-configuration provider specification from specs/scope-configuration.json.tpl. Set it to true only when the scope ships that file.",
      "required": false
    },
    {
      "name": "scope_configuration_name_override",
      "description": "Name of the scope-configuration provider specification. Null uses the template's; override it when that name collides with one already visible in the organization. Same input as scope_definition's.",
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
      "name": "create_agent_channel",
      "description": "Create the agent channel that routes the scope's actions to the package worker. Turn it off when the organization creates its channels in a separate bindings layer with scope_definition_agent_association.",
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
    "notification_channel_id",
    "service_slug",
    "provider_specification_slug",
    "package_id",
    "package_default_version"
  ],
  "hash": "5865fe30479ddcedef082dddc6c1cca2"
}
END_AI_METADATA -->
