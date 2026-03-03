# Module: code_repository

## Description

Configures Git provider integration with Nullplatform for GitHub, GitLab, or Azure DevOps

## Features

- Supports multiple Git providers (GitHub, GitLab, Azure DevOps)
- Configures provider-specific authentication and access tokens
- Manages organization and project settings for each Git provider
- Configures repository collaborators and permissions for GitLab
- Handles provider-specific installation URLs and IDs
- Creates provider configuration resources based on selected Git provider

## Basic Usage

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v1.41.1"

  git_provider = "your-git-provider"
  np_api_key   = "your-np-api-key"
  nrn          = "your-nrn"
}
```

### Usage with GitHub Configuration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v1.41.1"

  git_provider           = "github"
  github_installation_id = "your-github-installation-id"  # Required when git_provider = "github"
  github_organization    = "your-github-organization"  # Required when git_provider = "github"
  np_api_key             = "your-np-api-key"
  nrn                    = "your-nrn"
}
```

### Usage with GitLab Configuration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v1.41.1"

  git_provider                = "gitlab"
  gitlab_access_token         = "your-gitlab-access-token"  # Required when git_provider = "gitlab"
  gitlab_collaborators_config = "your-gitlab-collaborators-config"  # Required when git_provider = "gitlab"
  gitlab_group_path           = "your-gitlab-group-path"  # Required when git_provider = "gitlab"
  gitlab_installation_url     = "your-gitlab-installation-url"  # Required when git_provider = "gitlab"
  gitlab_repository_prefix    = "your-gitlab-repository-prefix"  # Required when git_provider = "gitlab"
  gitlab_slug                 = "your-gitlab-slug"  # Required when git_provider = "gitlab"
  np_api_key                  = "your-np-api-key"
  nrn                         = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.code_repository.id
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
| [nullplatform_provider_config.azure](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |
| [nullplatform_provider_config.github](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |
| [nullplatform_provider_config.gitlab](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_access_token"></a> [azure\_access\_token](#input\_azure\_access\_token) | Azure devops personal access token | `string` | `null` | no |
| <a name="input_azure_agent_pool"></a> [azure\_agent\_pool](#input\_azure\_agent\_pool) | Azure devops CI agent pool | `string` | `"Default"` | no |
| <a name="input_azure_project"></a> [azure\_project](#input\_azure\_project) | Azure devops project name | `string` | `null` | no |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | Git provider to use (GitHub or GitLab). | `string` | n/a | yes |
| <a name="input_github_installation_id"></a> [github\_installation\_id](#input\_github\_installation\_id) | GitHub App installation ID for the organization. | `string` | `null` | no |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | GitHub organization name for repository creation. | `string` | `null` | no |
| <a name="input_gitlab_access_token"></a> [gitlab\_access\_token](#input\_gitlab\_access\_token) | Access token for authenticating with the Git provider API. | `string` | `null` | no |
| <a name="input_gitlab_collaborators_config"></a> [gitlab\_collaborators\_config](#input\_gitlab\_collaborators\_config) | Configuration for repository collaborators, including their roles and permissions. | <pre>object({<br/>    collaborators = list(object({<br/>      id   = string<br/>      role = string<br/>      type = string<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_gitlab_group_path"></a> [gitlab\_group\_path](#input\_gitlab\_group\_path) | GitLab group path where repositories will be created. | `string` | `null` | no |
| <a name="input_gitlab_installation_url"></a> [gitlab\_installation\_url](#input\_gitlab\_installation\_url) | Installation URL for the Git provider integration. | `string` | `null` | no |
| <a name="input_gitlab_repository_prefix"></a> [gitlab\_repository\_prefix](#input\_gitlab\_repository\_prefix) | Prefix to use for GitLab repository names. | `string` | `null` | no |
| <a name="input_gitlab_slug"></a> [gitlab\_slug](#input\_gitlab\_slug) | GitLab project slug identifier. | `string` | `null` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication. | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (NRN) — unique identifier for resources. | `string` | n/a | yes |
<!-- END_TF_DOCS -->
