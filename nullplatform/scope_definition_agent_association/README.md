# Module: Scope definition agent association

This Tofu code creates a notification channel in nullplatform that links to a specific NRN and can dynamically configure an agent-based channel when needed.
It injects the agent’s API key, command configuration, and optional overrides, while preserving any filters defined in the original template.

## Usage

```hcl
module "scope_definition_agent_association" {
  source                     = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition_association?ref=v1.0.0"
  nrn                        = var.nrn
  np_api_key                 = var.np_api_key
  service_specification_id   = module.scope_definition.service_specification_id
  service_specification_slug = module.scope_definition.service_slug
  tags_selectors             = var.tags_selectors
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
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) |  >= 0.0.67 |

## Resources

| Name | Type |
|------|------|
| [null_resource.clone_repo](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [nullplatform_api_key.nullplatform_agent_api_key](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/api_key) | resource |
| [nullplatform_notification_channel.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_enabled_override"></a> [enabled\_override](#input\_enabled\_override) | Enable custom overrides for scope configurations via command line | `bool` | `false` | no |
| <a name="input_github_ref"></a> [github\_ref](#input\_github\_ref) | Git reference to use (branch name, tag, or commit SHA) | `string` | `"beta"` | no |
| <a name="input_github_repo_url"></a> [github\_repo\_url](#input\_github\_repo\_url) | GitHub repository URL containing scope and action templates | `string` | `"https://github.com/nullplatform/scopes"` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | n/a | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | n/a | `string` | n/a | yes |
| <a name="input_override_repo_path"></a> [override\_repo\_path](#input\_override\_repo\_path) | Local filesystem path where the scope repository will be cloned | `string` | `null` | no |
| <a name="input_overrides_service_path"></a> [overrides\_service\_path](#input\_overrides\_service\_path) | Local filesystem path to the directory containing override configurations | `string` | `null` | no |
| <a name="input_repo_path"></a> [repo\_path](#input\_repo\_path) | Local filesystem path where the scope repository will be cloned | `string` | `"/root/.np/nullplatform/scopes"` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path to the service directory within the repository structure | `string` | `"k8s"` | no |
| <a name="input_service_specification_id"></a> [service\_specification\_id](#input\_service\_specification\_id) | n/a | `any` | n/a | yes |
| <a name="input_service_specification_slug"></a> [service\_specification\_slug](#input\_service\_specification\_slug) | n/a | `any` | n/a | yes |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter channels and agents | `map(string)` | n/a | yes |
<!-- END_TF_DOCS -->