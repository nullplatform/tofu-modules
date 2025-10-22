# Module: Code Repository

Sets up Nullplatform Git provider integrations for GitLab or GitHub, including collaborator access and installation metadata.

Usage for github:


```
module "code_repository" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/code_repository?ref=v1.0.0"
  git_provider                 = "github"
  np_api_key                   = var.np_api_key
  nrn                          = var.nrn
  github_organization          = var.github_organization
  github_installation_id       = var.github_installation_id

}
```
Usage for gitlab:

```
module "code_repository" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git///nullplatform/code_repository?ref=v1.0.0"
  git_provider                 = "gitlab"
  np_api_key                   = var.np_api_key
  nrn                          = var.nrn
  gitlab_group_path            = var.gitlab_group_path
  gitlab_access_token          = var.gitlab_access_token
  gitlab_installation_url      = var.gitlab_installation_url

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

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.github](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |
| [nullplatform_provider_config.gitlab](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_token"></a> [access\_token](#input\_access\_token) | Access token for authenticating with the Git provider API | `string` | `null` | no |
| <a name="input_collaborators_config"></a> [collaborators\_config](#input\_collaborators\_config) | Configuration for repository collaborators with their roles and permissions | <pre>object({<br/>    collaborators = list(object({<br/>      id   = string<br/>      role = string<br/>      type = string<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | Git provider to use (github or gitlab) | `string` | n/a | yes |
| <a name="input_gitlab_repository_prefix"></a> [gitlab\_repository\_prefix](#input\_gitlab\_repository\_prefix) | Prefix to use for GitLab repository names | `string` | `null` | no |
| <a name="input_gitlab_slug"></a> [gitlab\_slug](#input\_gitlab\_slug) | GitLab project slug identifier | `string` | `null` | no |
| <a name="input_group_path"></a> [group\_path](#input\_group\_path) | GitLab group path where repositories will be created | `string` | `null` | no |
| <a name="input_installation_url"></a> [installation\_url](#input\_installation\_url) | Installation URL for the Git provider integration | `string` | `null` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name - unique identifier for resources | `string` | n/a | yes |
| <a name="input_organization"></a> [organization](#input\_organization) | GitHub organization name for repository creation | `string` | `null` | no |
| <a name="input_organization_installation_id"></a> [organization\_installation\_id](#input\_organization\_installation\_id) | GitHub App installation ID for the organization | `string` | `null` | no |
<!-- END_TF_DOCS -->
