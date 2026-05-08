# Module: service_definition_agent_association

## Description

Creates a nullplatform notification channel configured with an agent that executes a repository-based entrypoint for handling notifications

## Architecture

The module creates a nullplatform_notification_channel resource wired to an agent configuration that executes a cmdline path built from repository_service_spec_repo and service_path. A terraform_data resource monitors api_key changes to trigger replacement of the channel. The agent selector uses tags_selectors to filter targets, and the channel applies filters based on service.specification.slug.

## Features

- Creates nullplatform notification channel with agent-based execution
- Configures agent command with dynamic path from repository and service path
- Supports tag-based agent selection via selector map
- Applies service specification slug filters to incoming notifications
- Triggers channel replacement on API key rotation

## Basic Usage

```hcl
module "service_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_definition_agent_association?ref=v2.3.0"

  api_key                      = "your-api-key"
  repository_service_spec_repo = "your-repository-service-spec-repo"
  service_path                 = "your-service-path"
  tags_selectors               = "your-tags-selectors"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.service_definition_agent_association.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.86 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.channel_from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |
| [terraform_data.api_key_trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_arguments"></a> [agent\_arguments](#input\_agent\_arguments) | Arguments to pass to the agent entrypoint command | `list(string)` | `[]` | no |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key for authenticating with the nullplatform API | `string` | n/a | yes |
| <a name="input_base_clone_path"></a> [base\_clone\_path](#input\_base\_clone\_path) | Base path where the service repository is cloned inside the agent pod | `string` | `"/root/.np"` | no |
| <a name="input_channel_sources"></a> [channel\_sources](#input\_channel\_sources) | List of sources for the notification channel (e.g., ['monitoring', 'alerts']) | `list(string)` | <pre>[<br/>  "telemetry",<br/>  "service"<br/>]</pre> | no |
| <a name="input_channel_type"></a> [channel\_type](#input\_channel\_type) | Type of the notification channel (e.g., 'agent') | `string` | `"agent"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | `null` | no |
| <a name="input_repository_service_spec_repo"></a> [repository\_service\_spec\_repo](#input\_repository\_service\_spec\_repo) | GitHub repository name containing the service specs (used to build the agent cmdline path) | `string` | n/a | yes |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to the service directory within the repository (e.g., databases/postgres/k8s) | `string` | n/a | yes |
| <a name="input_service_specification_slug"></a> [service\_specification\_slug](#input\_service\_specification\_slug) | The slug of the service definition | `string` | `null` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter agents | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created notification channel |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "service_definition_agent_association",
  "description": "Creates a nullplatform notification channel configured with an agent that executes a repository-based entrypoint for handling notifications",
  "architecture": "The module creates a nullplatform_notification_channel resource wired to an agent configuration that executes a cmdline path built from repository_service_spec_repo and service_path. A terraform_data resource monitors api_key changes to trigger replacement of the channel. The agent selector uses tags_selectors to filter targets, and the channel applies filters based on service.specification.slug.",
  "features": [
    "Creates nullplatform notification channel with agent-based execution",
    "Configures agent command with dynamic path from repository and service path",
    "Supports tag-based agent selection via selector map",
    "Applies service specification slug filters to incoming notifications",
    "Triggers channel replacement on API key rotation"
  ],
  "inputs": [
    {
      "name": "api_key",
      "description": "API key for authenticating with the nullplatform API",
      "required": true
    },
    {
      "name": "tags_selectors",
      "description": "Map of tags used to select and filter agents",
      "required": true
    },
    {
      "name": "repository_service_spec_repo",
      "description": "GitHub repository name containing the service specs (used to build the agent cmdline path)",
      "required": true
    },
    {
      "name": "service_path",
      "description": "Path to the service directory within the repository (e.g., databases/postgres/k8s)",
      "required": true
    },
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (organization:account format)",
      "required": false
    },
    {
      "name": "channel_sources",
      "description": "List of sources for the notification channel (e.g., ['monitoring', 'alerts'])",
      "required": false
    },
    {
      "name": "channel_type",
      "description": "Type of the notification channel (e.g., 'agent')",
      "required": false
    },
    {
      "name": "service_specification_slug",
      "description": "The slug of the service definition",
      "required": false
    },
    {
      "name": "base_clone_path",
      "description": "Base path where the service repository is cloned inside the agent pod",
      "required": false
    },
    {
      "name": "agent_arguments",
      "description": "Arguments to pass to the agent entrypoint command",
      "required": false
    }
  ],
  "outputs": [
    "id"
  ],
  "hash": "2261d6bc1c700912722065e90d68238a"
}
END_AI_METADATA -->
