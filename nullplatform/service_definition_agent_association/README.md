# Module: Service Definition Agent Association

This module creates a notification channel that associates agents with a specific service definition, enabling agent-based operations for services within that scope.

## Usage

```hcl
module "service_definition_agent_association" {
  source                     = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_definition_agent_association?ref=main"
  nrn                        = var.nrn
  tags_selectors             = var.tags_selectors
  service_specification_id   = module.service_definition.service_specification_id
  service_specification_slug = module.service_definition.service_slug
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.67 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | >= 0.0.67 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_api_key"></a> [api\_key](#module\_api\_key) | git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key | main |

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.channel_from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | `null` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter agents | `map(string)` | n/a | yes |
| <a name="input_channel_sources"></a> [channel\_sources](#input\_channel\_sources) | List of sources for the notification channel | `list(string)` | `["telemetry", "service"]` | no |
| <a name="input_channel_type"></a> [channel\_type](#input\_channel\_type) | Type of the notification channel | `string` | `"agent"` | no |
| <a name="input_service_specification_slug"></a> [service\_specification\_slug](#input\_service\_specification\_slug) | The slug of the service definition | `string` | `null` | no |
| <a name="input_service_specification_id"></a> [service\_specification\_id](#input\_service\_specification\_id) | The ID of the service definition associated with the agent | `string` | `null` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to the service configuration | `string` | `null` | no |
| <a name="input_workflow_override_path"></a> [workflow\_override\_path](#input\_workflow\_override\_path) | Path to a custom workflow file to override the default one | `string` | `null` | no |
| <a name="input_workflow_override_values"></a> [workflow\_override\_values](#input\_workflow\_override\_values) | Values to override in the workflow file | `string` | `"null"` | no |
| <a name="input_agent_command"></a> [agent\_command](#input\_agent\_command) | Agent command configuration | `object` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created notification channel |
<!-- END_TF_DOCS -->
