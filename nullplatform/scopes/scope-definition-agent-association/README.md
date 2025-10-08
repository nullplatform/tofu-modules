## [ALPHA] Scope-Definition-Agent-Association module

This module creates a notification channel that associates agents with a specific scope definition, enabling agent-based operations for services within that scope.

## How to use it

```hcl
module "k8s_scope_definition" {
  source = "git@github.com:nullplatform/main-terraform-modules.git//modules/nullplatform/scope-definition?ref=alpha"
  nrn        = var.np_account_nrn
  np_api_key = var.np_api_key
  github_repo_url = "https://github.com/nullplatform/scopes"
  github_ref      = "features/specs_for_automation"
  github_scope_path = "k8s"
  scope_name        = "K8S Webserver"
  workflow_override_values = "../../nullplatform-training/partner-training/3-scopes-getting-started/scope-override/values.yaml"
  scope_description = "Webserver running in a Kubernetes cluster"
  
}

module "k8s_agent_asociation" {
  source = "git@github.com:nullplatform/main-terraform-modules.git//modules/nullplatform/scope-definition-agent-association?ref=alpha"
  agent_api_key = var.np_api_key
  scope_definition=module.k8s_scope_definition
  agent_tags = { "environment" = "demo", "training" = "ingenia", "cluster" = "geisbruch" }
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
| <a name="input_agent_api_key"></a> [agent\_api\_key](#input\_agent\_api\_key) | API key with permissions to run commands on agents (usually ops permissions) | `string` | n/a | yes |
| <a name="input_agent_command"></a> [agent\_command](#input\_agent\_command) | Agent command configuration | <pre>object({<br/>    type = string<br/>    data = object({<br/>      cmdline     = string<br/>      arguments   = optional(list(string), [])<br/>      environment = optional(map(string), {})<br/>    })<br/>  })</pre> | n/a | yes |
| <a name="input_agent_tags"></a> [agent\_tags](#input\_agent\_tags) | Agent tags for selector | `map(string)` | n/a | yes |
| <a name="input_channel_sources"></a> [channel\_sources](#input\_channel\_sources) | List of sources for the notification channel | `list(string)` | <pre>[<br/>  "telemetry",<br/>  "service"<br/>]</pre> | no |
| <a name="input_channel_type"></a> [channel\_type](#input\_channel\_type) | Type of the notification channel | `string` | `"agent"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | n/a | yes |
| <a name="input_scope_slug"></a> [scope\_slug](#input\_scope\_slug) | The slug of the scope definition | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the created notification channel |