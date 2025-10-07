
# Modules: code repository

This module allows you to create accounts in your nullplatform organization.

Usage for github:


```
module "code_repository" {
  source                       = "git@github.com:nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v0.0.1"
  git_provider                 = "github"
  np_api_key                   = var.np_api_key
  nrn                          = var.nrn
  organization                 = var.organization
  organization_installation_id = var.organization_installation_id

}
```
Usage for gitlab:

```
module "code_repository" {
  source                       = "git@github.com:nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v0.0.1"
  git_provider                 = "gitlab"
  np_api_key                   = var.np_api_key
  nrn                          = var.nrn
  group_path                   = var.group_path
  access_token                 = var.access_token
  installation_url             = var.installation_url

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
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.68 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.github](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |
| [nullplatform_provider_config.gitlab](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_token"></a> [access\_token](#input\_access\_token) | n/a | `string` | n/a | yes |
| <a name="input_collaborators_config"></a> [collaborators\_config](#input\_collaborators\_config) | n/a | <pre>object({<br/>    collaborators = list(object({<br/>      id   = string<br/>      role = string<br/>      type = string<br/>    }))<br/>  })</pre> | n/a | yes |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | gitlab or github | `string` | n/a | yes |
| <a name="input_gitlab_name"></a> [gitlab\_name](#input\_gitlab\_name) | n/a | `string` | n/a | yes |
| <a name="input_gitlab_repository_prefix"></a> [gitlab\_repository\_prefix](#input\_gitlab\_repository\_prefix) | n/a | `string` | n/a | yes |
| <a name="input_gitlab_slug"></a> [gitlab\_slug](#input\_gitlab\_slug) | n/a | `string` | n/a | yes |
| <a name="input_group_path"></a> [group\_path](#input\_group\_path) | n/a | `string` | n/a | yes |
| <a name="input_installation_url"></a> [installation\_url](#input\_installation\_url) | n/a | `string` | n/a | yes |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | n/a | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | n/a | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | n/a | `string` | `""` | no |
| <a name="input_organization_installation_id"></a> [organization\_installation\_id](#input\_organization\_installation\_id) | n/a | `string` | `""` | no |
| <a name="input_repository_provider"></a> [repository\_provider](#input\_repository\_provider) | n/a | `string` | n/a | yes |
<!-- END_TF_DOCS -->