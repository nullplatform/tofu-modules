# Module: scope_definition_agent_association

## Description

Creates a nullplatform notification channel from a remote JSON template with dynamic agent configuration and optional override support

## Architecture

The module fetches a notification-channel.json.tpl template via data.http, processes it with data.external using gomplate to inject NRN, API key, and service metadata, then creates a nullplatform_notification_channel resource. When type is agent, it dynamically builds an agent block with command data, optionally appending an overrides flag if enabled_override is true. The api_key change triggers replacement through terraform_data.api_key_trigger.

## Features

- Fetches and renders remote JSON templates with gomplate variable substitution
- Configures agent-based channels with injected NP_ACTION_CONTEXT environment and conditional cmdline overrides
- Supports lifecycle ignore for filters, source, and type to preserve external changes
- Enables optional command-line overrides via enabled_override flag and local.overrides_flag injection

## Basic Usage

```hcl
module "scope_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition_agent_association?ref=v2.0.2"

  api_key                  = "your-api-key"
  nrn                      = "your-nrn"
  scope_specification_id   = "your-scope-specification-id"
  scope_specification_slug = "your-scope-specification-slug"
  tags_selectors           = "your-tags-selectors"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.scope_definition_agent_association.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) |  >= 0.0.67 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) |  >= 0.0.67 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Resources

| Name | Type |
|------|------|
| [nullplatform_notification_channel.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |
| [terraform_data.api_key_trigger](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_api_key"></a> [api\_key](#input\_api\_key) | API key for authenticating with the nullplatform API | `string` | n/a | yes |
| <a name="input_enabled_override"></a> [enabled\_override](#input\_enabled\_override) | Enable custom overrides for scope configurations via command line | `bool` | `false` | no |
| <a name="input_github_ref"></a> [github\_ref](#input\_github\_ref) | Git reference to use (branch name, tag, or commit SHA) | `string` | `"beta"` | no |
| <a name="input_github_repo_url"></a> [github\_repo\_url](#input\_github\_repo\_url) | GitHub repository URL containing scope and action templates | `string` | `"https://github.com/nullplatform/scopes"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | n/a | `string` | n/a | yes |
| <a name="input_override_repo_path"></a> [override\_repo\_path](#input\_override\_repo\_path) | Local filesystem path where the scope repository will be cloned | `string` | `null` | no |
| <a name="input_overrides_service_path"></a> [overrides\_service\_path](#input\_overrides\_service\_path) | Local filesystem path to the directory containing override configurations | `string` | `null` | no |
| <a name="input_repo_path"></a> [repo\_path](#input\_repo\_path) | Local filesystem path where the scope repository will be cloned | `string` | `"/root/.np/nullplatform/scopes"` | no |
| <a name="input_repository_notification_channel"></a> [repository\_notification\_channel](#input\_repository\_notification\_channel) | repository of notification channel template | `string` | `"https://raw.githubusercontent.com/nullplatform/scopes/refs/heads"` | no |
| <a name="input_repository_notification_channel_branch"></a> [repository\_notification\_channel\_branch](#input\_repository\_notification\_channel\_branch) | branch reference of notification channel template | `string` | `"main"` | no |
| <a name="input_scope_specification_id"></a> [scope\_specification\_id](#input\_scope\_specification\_id) | n/a | `any` | n/a | yes |
| <a name="input_scope_specification_slug"></a> [scope\_specification\_slug](#input\_scope\_specification\_slug) | n/a | `any` | n/a | yes |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to the service directory within the repository structure | `string` | `"k8s"` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter channels and agents | `map(string)` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "scope_definition_agent_association",
  "description": "Creates a nullplatform notification channel from a remote JSON template with dynamic agent configuration and optional override support",
  "architecture": "The module fetches a notification-channel.json.tpl template via data.http, processes it with data.external using gomplate to inject NRN, API key, and service metadata, then creates a nullplatform_notification_channel resource. When type is agent, it dynamically builds an agent block with command data, optionally appending an overrides flag if enabled_override is true. The api_key change triggers replacement through terraform_data.api_key_trigger.",
  "features": [
    "Fetches and renders remote JSON templates with gomplate variable substitution",
    "Configures agent-based channels with injected NP_ACTION_CONTEXT environment and conditional cmdline overrides",
    "Supports lifecycle ignore for filters, source, and type to preserve external changes",
    "Enables optional command-line overrides via enabled_override flag and local.overrides_flag injection"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "",
      "required": true
    },
    {
      "name": "api_key",
      "description": "API key for authenticating with the nullplatform API",
      "required": true
    },
    {
      "name": "scope_specification_id",
      "description": "",
      "required": true
    },
    {
      "name": "scope_specification_slug",
      "description": "",
      "required": true
    },
    {
      "name": "tags_selectors",
      "description": "Map of tags used to select and filter channels and agents",
      "required": true
    },
    {
      "name": "enabled_override",
      "description": "Enable custom overrides for scope configurations via command line",
      "required": false
    },
    {
      "name": "overrides_service_path",
      "description": "Local filesystem path to the directory containing override configurations",
      "required": false
    },
    {
      "name": "override_repo_path",
      "description": "Local filesystem path where the scope repository will be cloned",
      "required": false
    },
    {
      "name": "github_repo_url",
      "description": "GitHub repository URL containing scope and action templates",
      "required": false
    },
    {
      "name": "github_ref",
      "description": "Git reference to use (branch name, tag, or commit SHA)",
      "required": false
    },
    {
      "name": "repository_notification_channel",
      "description": "repository of notification channel template",
      "required": false
    },
    {
      "name": "repository_notification_channel_branch",
      "description": "branch reference of notification channel template",
      "required": false
    },
    {
      "name": "service_path",
      "description": "Path to the service directory within the repository structure",
      "required": false
    },
    {
      "name": "repo_path",
      "description": "Local filesystem path where the scope repository will be cloned",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "35662763a1ad494fa9d5afe0b000dc98"
}
END_AI_METADATA -->
