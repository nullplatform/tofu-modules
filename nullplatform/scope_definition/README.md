# Module: scope_definition

## Description

Creates and configures nullplatform service specifications, scope types, and action specifications from remote template files with gomplate-based rendering

## Architecture

The module fetches JSON templates via data.http from a remote repository, processes them using external data sources with gomplate and jq for variable substitution, then creates nullplatform_service_specification resources with associated selectors and attributes. It creates nullplatform_scope_type resources linked to the service specification via provider_id, and generates multiple nullplatform_action_specification resources for each action defined in action_spec_names. A null_resource with local-exec provisioner patches the NRN configuration using the nullplatform CLI to set metrics and logging providers. Optionally creates nullplatform_provider_specification resources from scope configuration templates when create_scope_configuration is true.

## Features

- Fetches and processes service specification templates from remote GitHub repositories using gomplate
- Creates nullplatform service specifications with selectors for category, provider, and sub-category
- Generates scope types linked to service specifications with provider type definitions
- Creates multiple action specifications for scope lifecycle operations including deployment and scaling actions
- Patches NRN configuration with external metrics and logging provider settings via nullplatform CLI
- Supports optional provider specification creation from scope configuration templates
- Processes templates with dynamic variable substitution using NRN, service IDs, and path context

## Basic Usage

```hcl
module "scope_definition" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition?ref=v1.52.0"

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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.3.5 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.2.4 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

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
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key used for executing local commands (e.g., 'np nrn patch') | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Unique NRN identifier of the environment or resource in nullplatform | `string` | n/a | yes |
| <a name="input_repo_path"></a> [repo\_path](#input\_repo\_path) | Base path to the repository used as context for gomplate template rendering | `string` | `"/root/.np/nullplatform/scopes"` | no |
| <a name="input_repository_action_templates"></a> [repository\_action\_templates](#input\_repository\_action\_templates) | repository of action template | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_action_templates_branch"></a> [repository\_action\_templates\_branch](#input\_repository\_action\_templates\_branch) | branch reference of action template | `string` | `"main"` | no |
| <a name="input_repository_scope_template"></a> [repository\_scope\_template](#input\_repository\_scope\_template) | repository of scope template | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_scope_template_branch"></a> [repository\_scope\_template\_branch](#input\_repository\_scope\_template\_branch) | branch reference of scope template | `string` | `"main"` | no |
| <a name="input_repository_service_spec"></a> [repository\_service\_spec](#input\_repository\_service\_spec) | repository of service spec | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_service_spec_branch"></a> [repository\_service\_spec\_branch](#input\_repository\_service\_spec\_branch) | branch reference of service spec | `string` | `"main"` | no |
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
  "description": "Creates and configures nullplatform service specifications, scope types, and action specifications from remote template files with gomplate-based rendering",
  "architecture": "The module fetches JSON templates via data.http from a remote repository, processes them using external data sources with gomplate and jq for variable substitution, then creates nullplatform_service_specification resources with associated selectors and attributes. It creates nullplatform_scope_type resources linked to the service specification via provider_id, and generates multiple nullplatform_action_specification resources for each action defined in action_spec_names. A null_resource with local-exec provisioner patches the NRN configuration using the nullplatform CLI to set metrics and logging providers. Optionally creates nullplatform_provider_specification resources from scope configuration templates when create_scope_configuration is true.",
  "features": [
    "Fetches and processes service specification templates from remote GitHub repositories using gomplate",
    "Creates nullplatform service specifications with selectors for category, provider, and sub-category",
    "Generates scope types linked to service specifications with provider type definitions",
    "Creates multiple action specifications for scope lifecycle operations including deployment and scaling actions",
    "Patches NRN configuration with external metrics and logging provider settings via nullplatform CLI",
    "Supports optional provider specification creation from scope configuration templates",
    "Processes templates with dynamic variable substitution using NRN, service IDs, and path context"
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
  "hash": "38143399d1ff91a802e0a4a9b39a99e7"
}
END_AI_METADATA -->
