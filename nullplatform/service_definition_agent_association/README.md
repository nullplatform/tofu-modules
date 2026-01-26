## [ALPHA] Service-Definition-Agent-Association module

This module creates a notification channel that associates agents with a specific service definition, enabling agent-based operations for services within that scope.

## How to use it

```hcl
module "service_definition" {
  source = "git@github.com:nullplatform/main-terraform-modules.git//modules/nullplatform/service-definition?ref=alpha"
  nrn                 = var.np_account_nrn
  np_api_key          = var.np_api_key
  git_repo            = "nullplatform/services"
  git_ref             = "main"
  git_service_path    = "databases/postgres/k8s"
  service_name        = "PostgreSQL Database"
  service_description = "PostgreSQL database service running in Kubernetes"
}

module "service_agent_association" {
  source = "git@github.com:nullplatform/main-terraform-modules.git//modules/nullplatform/service-definition-agent-association?ref=alpha"
  agent_api_key = var.np_api_key
  service_definition = module.service_definition
  agent_tags = { "environment" = "production", "cluster" = "k8s-prod" }
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.channel_from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_api_key"></a> [agent\_api\_key](#input\_agent\_api\_key) | API key with permsissions to run commands on agents (usually ops permisions) | `string` | n/a | yes |
| <a name="input_agent_command"></a> [agent\_command](#input\_agent\_command) | Agent command configuration | <pre>object({<br/>    type = string<br/>    data = object({<br/>      cmdline     = string<br/>      arguments   = optional(list(string), [])<br/>      environment = optional(map(string), {})<br/>    })<br/>  })</pre> | `null` | no |
| <a name="input_agent_tags"></a> [agent\_tags](#input\_agent\_tags) | Agent tags | `map(string)` | n/a | yes |
| <a name="input_channel_sources"></a> [channel\_sources](#input\_channel\_sources) | List of sources for the notification channel (e.g., ['monitoring', 'alerts']) | `list(string)` | <pre>[<br/>  "telemetry",<br/>  "service"<br/>]</pre> | no |
| <a name="input_channel_type"></a> [channel\_type](#input\_channel\_type) | Type of the notification channel (e.g., 'agent') | `string` | `"agent"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | `null` | no |
| <a name="input_service_definition"></a> [service\_definition](#input\_service\_definition) | The service definition object from the service-definition module | <pre>object({<br/>    nrn = string,<br/>    slug = string,<br/>    workflow_override_path = string,<br/>    workflow_override_values = string,<br/>    service_specification_id = string,<br/>    specification = object({<br/>      agent_command = object({<br/>        type = string<br/>        data = object({<br/>          cmdline     = string<br/>          arguments   = optional(list(string), [])<br/>          environment = optional(map(string), {})<br/>        })<br/>      })<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_service_slug"></a> [service\_slug](#input\_service\_slug) | The slug of the scope definition | `string` | `null` | no |
| <a name="input_service_specification_id"></a> [service\_specification\_id](#input\_service\_specification\_id) | The ID of the service definition associated with the agent | `string` | `null` | no |
| <a name="input_workflow_override_path"></a> [workflow\_override\_path](#input\_workflow\_override\_path) | Path to a custom workflow file to override the default one | `string` | `null` | no |
| <a name="input_workflow_override_values"></a> [workflow\_override\_values](#input\_workflow\_override\_values) | Values to override in the workflow file | `string` | `"null"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created notification channel |
<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | n/a |

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
| <a name="input_agent_command"></a> [agent\_command](#input\_agent\_command) | n/a | <pre>object({<br/>    type = string<br/>    data = object({<br/>      cmdline     = string<br/>      arguments   = optional(list(string), [])<br/>      environment = optional(map(string), {})<br/>    })<br/>  })</pre> | `null` | no |
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