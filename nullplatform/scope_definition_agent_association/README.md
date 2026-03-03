# Module: scope_definition_agent_association

## Description

Creates a Nullplatform notification channel with dynamic configuration from templates and optional override support

## Features

- Fetches notification channel template from a remote repository
- Processes templates with service and API context using gomplate
- Configures agent-based notification channels with command execution
- Supports optional configuration overrides via command line flags
- Manages channel lifecycle with API key change detection
- Injects environment variables and custom tags for channel selection

## Basic Usage

```hcl
module "scope_definition_agent_association" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition_agent_association?ref=v1.41.1"

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
| <a name="input_scope_specification_id"></a> [scope\_specification\_id](#input\_scope\_specification\_id) | n/a | `any` | n/a | yes |
| <a name="input_scope_specification_slug"></a> [scope\_specification\_slug](#input\_scope\_specification\_slug) | n/a | `any` | n/a | yes |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to the service directory within the repository structure | `string` | `"k8s"` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter channels and agents | `map(string)` | n/a | yes |
<!-- END_TF_DOCS -->
