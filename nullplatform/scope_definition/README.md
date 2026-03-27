# Module: scope_definition

## Description

This module provisions a nullplatform service specification with linked scope types and action specifications from remote JSON templates

## Architecture

data.http resources fetch JSON templates from GitHub, data.external resources render them with gomplate, nullplatform_service_specification creates the service spec, nullplatform_scope_type links a scope type to that spec, nullplatform_action_specification resources create multiple actions, and a null_resource patches the NRN with provider metadata via local-exec

## Features

- Fetches and renders remote JSON templates using gomplate with NRN context
- Creates service specification with selectors and lifecycle policies
- Links scope type to service specification for environment scoping
- Generates multiple action specifications for deployment and scaling operations
- Patches NRN with external metrics and logging provider configuration

## Basic Usage

```hcl
module "scope_definition" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition?ref=v1.48.2"

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
  "description": "This module provisions a nullplatform service specification with linked scope types and action specifications from remote JSON templates",
  "architecture": "data.http resources fetch JSON templates from GitHub, data.external resources render them with gomplate, nullplatform_service_specification creates the service spec, nullplatform_scope_type links a scope type to that spec, nullplatform_action_specification resources create multiple actions, and a null_resource patches the NRN with provider metadata via local-exec",
  "features": [
    "Fetches and renders remote JSON templates using gomplate with NRN context",
    "Creates service specification with selectors and lifecycle policies",
    "Links scope type to service specification for environment scoping",
    "Generates multiple action specifications for deployment and scaling operations",
    "Patches NRN with external metrics and logging provider configuration"
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
    }
  ],
  "outputs": [
    "service_specification_id",
    "service_slug",
    "scope_type_id",
    "actions_created"
  ],
  "hash": "ae918374b3413dc51f7bad3784707086"
}
END_AI_METADATA -->
