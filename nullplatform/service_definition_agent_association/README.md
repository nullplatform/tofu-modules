# Module: service_definition_agent_association

## Description

Creates a Nullplatform notification channel with agent configuration and service filtering capabilities

## Features

- Creates a Nullplatform notification channel with configurable type and sources
- Configures agent commands with dynamic command-line arguments and environment variables
- Supports tag-based selector filtering for agent targeting
- Filters notifications based on service specification slug
- Manages workflow override paths and service paths for custom configurations
- Implements lifecycle management with API key-triggered replacement
- Provides flexible command execution with optional arguments and environment settings

## Basic Usage

```hcl
module "service_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_definition_agent_association?ref=v1.42.0"

  api_key        = "your-api-key"
  tags_selectors = "your-tags-selectors"
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


## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | n/a |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.channel_from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |
| [terraform_data.api_key_trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_command"></a> [agent\_command](#input\_agent\_command) | n/a | <pre>object({<br/>    type = string<br/>    data = object({<br/>      cmdline     = string<br/>      arguments   = optional(list(string), [])<br/>      environment = optional(map(string), {})<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key for authenticating with the nullplatform API | `string` | n/a | yes |
| <a name="input_channel_sources"></a> [channel\_sources](#input\_channel\_sources) | List of sources for the notification channel (e.g., ['monitoring', 'alerts']) | `list(string)` | <pre>[<br/>  "telemetry",<br/>  "service"<br/>]</pre> | no |
| <a name="input_channel_type"></a> [channel\_type](#input\_channel\_type) | Type of the notification channel (e.g., 'agent') | `string` | `"agent"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | `null` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to the service configuration | `string` | `null` | no |
| <a name="input_service_specification_id"></a> [service\_specification\_id](#input\_service\_specification\_id) | The ID of the service definition associated with the agent | `string` | `null` | no |
| <a name="input_service_specification_slug"></a> [service\_specification\_slug](#input\_service\_specification\_slug) | The slug of the service definition | `string` | `null` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter agents | `map(string)` | n/a | yes |
| <a name="input_workflow_override_path"></a> [workflow\_override\_path](#input\_workflow\_override\_path) | Path to a custom workflow file to override the default one | `string` | `null` | no |
| <a name="input_workflow_override_values"></a> [workflow\_override\_values](#input\_workflow\_override\_values) | Values to override in the workflow file | `string` | `"null"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created notification channel |
<!-- END_TF_DOCS -->
