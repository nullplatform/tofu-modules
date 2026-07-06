# Module: scope_definition

## Description

Provisions nullplatform service specifications, scope types, and action specifications by fetching and rendering gomplate templates from a remote repository, then patching NRN configuration with external provider settings

## Architecture

The module fetches JSON templates via `data.http` resources and processes them through `data.external` using gomplate shell commands, then feeds the rendered output into `nullplatform_service_specification`, `nullplatform_scope_type`, and `nullplatform_action_specification` resources. A `null_resource` with a local-exec provisioner runs the `np nrn patch` CLI command to configure external metrics and logging providers against the NRN. Optionally, a `nullplatform_provider_specification` is created from a scope configuration template when `create_scope_configuration` is true. All resources are chained via `depends_on` to enforce the correct creation order from template fetch through resource instantiation.

## Features

- Creates nullplatform_service_specification from a remotely fetched and gomplate-rendered JSON template
- Creates nullplatform_scope_type linked to the service specification with provider type resolved from template
- Creates multiple nullplatform_action_specification resources for each action name in the configurable action list
- Patches NRN configuration with external metrics and logging provider names via the np CLI
- Optionally creates nullplatform_provider_specification from a scope-configuration template when enabled
- Supports cross-account visibility sharing by appending extra NRNs to visible_to on service and provider specifications
- Supports optional name override for provider specifications to avoid slug collisions in multi-account organizations

## Basic Usage

```hcl
module "scope_definition" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition?ref=v6.2.0"

  np_api_key = "your-np-api-key"
  nrn        = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.scope_definition.service_specification_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.4 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | 2.3.5 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.5.0 |
| <a name="provider_null"></a> [null](#provider\_null) | 3.2.4 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [null_resource.nrn_patch](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [nullplatform_action_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/action_specification) | resource |
| [nullplatform_provider_specification.from_scope_configuration](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_specification) | resource |
| [nullplatform_scope_type.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/scope_type) | resource |
| [nullplatform_service_specification.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/service_specification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_spec_names"></a> [action\_spec\_names](#input\_action\_spec\_names) | List of action specification template names to fetch and create for scope operations | `list(string)` | <pre>[<br/>  "create-scope",<br/>  "delete-scope",<br/>  "start-initial",<br/>  "start-blue-green",<br/>  "finalize-blue-green",<br/>  "rollback-deployment",<br/>  "delete-deployment",<br/>  "switch-traffic",<br/>  "set-desired-instance-count",<br/>  "pause-autoscaling",<br/>  "resume-autoscaling",<br/>  "restart-pods",<br/>  "kill-instances",<br/>  "diagnose-deployment",<br/>  "diagnose-scope"<br/>]</pre> | no |
| <a name="input_create_scope_configuration"></a> [create\_scope\_configuration](#input\_create\_scope\_configuration) | Whether to fetch and apply scope-configuration.json.tpl from the template repo. Set to true only if the file exists for this scope. | `bool` | `false` | no |
| <a name="input_external_logging_provider"></a> [external\_logging\_provider](#input\_external\_logging\_provider) | Name of the external log provider | `string` | `"external"` | no |
| <a name="input_external_metrics_provider"></a> [external\_metrics\_provider](#input\_external\_metrics\_provider) | Name of the external metrics provider for monitoring integration | `string` | `"externalmetrics"` | no |
| <a name="input_extra_visible_to_nrns"></a> [extra\_visible\_to\_nrns](#input\_extra\_visible\_to\_nrns) | Additional NRNs to add to `visible_to` of the `nullplatform_service_specification`<br/>and `nullplatform_provider_specification` created by this module. The base<br/>visible\_to (the spec template's value for the service\_spec, and `[var.nrn]`<br/>for the provider\_spec) is preserved; this list is appended.<br/><br/>Use case: share a scope\_definition with sibling accounts in the same<br/>organization without duplicating it per account. Example:<br/><br/>  extra\_visible\_to\_nrns = ["organization=1636958496"]<br/><br/>makes the spec consumable by every account under that organization.<br/>Default = [] (no extra visibility, backwards compatible). | `list(string)` | `[]` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key used for executing local commands (e.g., 'np nrn patch') | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Unique NRN identifier of the environment or resource in nullplatform | `string` | n/a | yes |
| <a name="input_repo_path"></a> [repo\_path](#input\_repo\_path) | Base path to the repository used as context for gomplate template rendering | `string` | `"/root/.np/nullplatform/scopes"` | no |
| <a name="input_repository_action_templates"></a> [repository\_action\_templates](#input\_repository\_action\_templates) | repository of action template | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_action_templates_branch"></a> [repository\_action\_templates\_branch](#input\_repository\_action\_templates\_branch) | branch reference of action template | `string` | `"main"` | no |
| <a name="input_repository_scope_template"></a> [repository\_scope\_template](#input\_repository\_scope\_template) | repository of scope template | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_scope_template_branch"></a> [repository\_scope\_template\_branch](#input\_repository\_scope\_template\_branch) | branch reference of scope template | `string` | `"main"` | no |
| <a name="input_repository_service_spec"></a> [repository\_service\_spec](#input\_repository\_service\_spec) | repository of service spec | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_service_spec_branch"></a> [repository\_service\_spec\_branch](#input\_repository\_service\_spec\_branch) | branch reference of service spec | `string` | `"main"` | no |
| <a name="input_scope_configuration_name_override"></a> [scope\_configuration\_name\_override](#input\_scope\_configuration\_name\_override) | Optional override for the `name` of the `nullplatform_provider_specification`<br/>created from `scope-configuration.json.tpl` (when `create_scope_configuration = true`).<br/><br/>Default `null` -> use the `name` field from the template, preserving<br/>current behavior. Set to a string when consuming this module from a<br/>setup where the template's name would collide with an existing<br/>org-visible provider\_specification (e.g., a hub/principal account<br/>already registered the canonical "Static Files" / "AWS Lambda" name<br/>org-wide, and a sibling spoke account needs an account-local copy<br/>with a distinct name).<br/><br/>The `slug` is auto-derived server-side from the name; pass a name<br/>that will produce a unique slug per the API uniqueness constraints<br/>(name must be unique across `visible_to` overlaps in the same org).<br/><br/>Example:<br/><br/>  scope\_configuration\_name\_override = "Static Files Galicia 3"<br/><br/>Default = null (no override, backwards compatible). | `string` | `null` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path within the repository where the service specification files are stored (e.g., 'services/api') | `string` | `"k8s"` | no |
| <a name="input_service_spec_description"></a> [service\_spec\_description](#input\_service\_spec\_description) | Description of the created service or associated scope type | `string` | `"Docker containers on pods"` | no |
| <a name="input_service_spec_name"></a> [service\_spec\_name](#input\_service\_spec\_name) | Name of the service that will be created from the specification template | `string` | `"Containers"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_actions_created"></a> [actions\_created](#output\_actions\_created) | Map of all action specifications created from templates. |
| <a name="output_provider_specification_id"></a> [provider\_specification\_id](#output\_provider\_specification\_id) | The ID of the created provider specification, or null if scope configuration was not fetched |
| <a name="output_provider_specification_slug"></a> [provider\_specification\_slug](#output\_provider\_specification\_slug) | The slug of the created provider specification, or null if scope configuration was not fetched |
| <a name="output_scope_configuration"></a> [scope\_configuration](#output\_scope\_configuration) | Parsed scope configuration from scope-configuration.json.tpl, or null if not fetched |
| <a name="output_scope_type_id"></a> [scope\_type\_id](#output\_scope\_type\_id) | ID of the scope type created from the template. |
| <a name="output_service_slug"></a> [service\_slug](#output\_service\_slug) | Slug (unique name) of the service specification created in nullplatform. |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | ID of the service specification created in nullplatform. |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_definition",
  "description": "Provisions nullplatform service specifications, scope types, and action specifications by fetching and rendering gomplate templates from a remote repository, then patching NRN configuration with external provider settings",
  "architecture": "The module fetches JSON templates via `data.http` resources and processes them through `data.external` using gomplate shell commands, then feeds the rendered output into `nullplatform_service_specification`, `nullplatform_scope_type`, and `nullplatform_action_specification` resources. A `null_resource` with a local-exec provisioner runs the `np nrn patch` CLI command to configure external metrics and logging providers against the NRN. Optionally, a `nullplatform_provider_specification` is created from a scope configuration template when `create_scope_configuration` is true. All resources are chained via `depends_on` to enforce the correct creation order from template fetch through resource instantiation.",
  "features": [
    "Creates nullplatform_service_specification from a remotely fetched and gomplate-rendered JSON template",
    "Creates nullplatform_scope_type linked to the service specification with provider type resolved from template",
    "Creates multiple nullplatform_action_specification resources for each action name in the configurable action list",
    "Patches NRN configuration with external metrics and logging provider names via the np CLI",
    "Optionally creates nullplatform_provider_specification from a scope-configuration template when enabled",
    "Supports cross-account visibility sharing by appending extra NRNs to visible_to on service and provider specifications",
    "Supports optional name override for provider specifications to avoid slug collisions in multi-account organizations"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Unique NRN identifier of the environment or resource in nullplatform",
      "required": true
    },
    {
      "name": "np_api_key",
      "description": "Nullplatform API key used for executing local commands (e.g., 'np nrn patch')",
      "required": true
    },
    {
      "name": "repository_service_spec",
      "description": "repository of service spec",
      "required": false
    },
    {
      "name": "repository_service_spec_branch",
      "description": "branch reference of service spec",
      "required": false
    },
    {
      "name": "repository_scope_template",
      "description": "repository of scope template",
      "required": false
    },
    {
      "name": "repository_scope_template_branch",
      "description": "branch reference of scope template",
      "required": false
    },
    {
      "name": "repository_action_templates",
      "description": "repository of action template",
      "required": false
    },
    {
      "name": "repository_action_templates_branch",
      "description": "branch reference of action template",
      "required": false
    },
    {
      "name": "service_path",
      "description": "Path within the repository where the service specification files are stored (e.g., 'services/api')",
      "required": false
    },
    {
      "name": "repo_path",
      "description": "Base path to the repository used as context for gomplate template rendering",
      "required": false
    },
    {
      "name": "action_spec_names",
      "description": "List of action specification template names to fetch and create for scope operations",
      "required": false
    },
    {
      "name": "service_spec_name",
      "description": "Name of the service that will be created from the specification template",
      "required": false
    },
    {
      "name": "service_spec_description",
      "description": "Description of the created service or associated scope type",
      "required": false
    },
    {
      "name": "external_metrics_provider",
      "description": "Name of the external metrics provider for monitoring integration",
      "required": false
    },
    {
      "name": "external_logging_provider",
      "description": "Name of the external log provider",
      "required": false
    },
    {
      "name": "create_scope_configuration",
      "description": "Whether to fetch and apply scope-configuration.json.tpl from the template repo. Set to true only if the file exists for this scope.",
      "required": false
    },
    {
      "name": "scope_configuration_name_override",
      "description": "",
      "required": false
    },
    {
      "name": "extra_visible_to_nrns",
      "description": "",
      "required": false
    }
  ],
  "outputs": [
    "service_specification_id",
    "service_slug",
    "scope_type_id",
    "actions_created",
    "scope_configuration",
    "provider_specification_id",
    "provider_specification_slug"
  ],
  "hash": "c0d3592b7cc0a39d0553390872743bda"
}
END_AI_METADATA -->
