# Module: code_repository

## Description

Configures Nullplatform provider integrations for GitHub, GitLab, or Azure DevOps

## Architecture

The module creates nullplatform_provider_config resources based on the git_provider selection. When git_provider is 'github', it creates a github-configuration resource with organization and installation_id attributes. When git_provider is 'gitlab', it creates a gitlab-configuration resource with group_path, access_token, installation_url, and collaborators_config attributes. When git_provider is 'azure', it creates an azure-devops-configuration resource with project, access_token, and agent_pool attributes. The NRN input is processed to extract the namespace identifier for each provider configuration.

## Features

- Creates provider-specific configurations in Nullplatform for GitHub, GitLab, or Azure DevOps
- Configures GitHub App integration with organization and installation ID
- Sets up GitLab group integration with access tokens and collaborator permissions
- Establishes Azure DevOps project integration with personal access tokens and agent pools

## Basic Usage

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v1.46.0"

  git_provider = "your-git-provider"
  np_api_key   = "your-np-api-key"
  nrn          = "your-nrn"
}
```

### Usage with GitHub Configuration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v1.46.0"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v1.46.0"

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

### Usage with Azure DevOps Configuration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v1.46.0"

  azure_access_token = "your-azure-access-token"  # Required when git_provider = "azure"
  azure_agent_pool   = "your-azure-agent-pool"  # Required when git_provider = "azure"
  azure_project      = "your-azure-project"  # Required when git_provider = "azure"
  git_provider       = "azure"
  np_api_key         = "your-np-api-key"
  nrn                = "your-nrn"
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

<!-- BEGIN_AI_METADATA
{
  "name": "code_repository",
  "description": "Configures Nullplatform provider integrations for GitHub, GitLab, or Azure DevOps",
  "architecture": "The module creates nullplatform_provider_config resources based on the git_provider selection. When git_provider is 'github', it creates a github-configuration resource with organization and installation_id attributes. When git_provider is 'gitlab', it creates a gitlab-configuration resource with group_path, access_token, installation_url, and collaborators_config attributes. When git_provider is 'azure', it creates an azure-devops-configuration resource with project, access_token, and agent_pool attributes. The NRN input is processed to extract the namespace identifier for each provider configuration.",
  "features": [
    "Creates provider-specific configurations in Nullplatform for GitHub, GitLab, or Azure DevOps",
    "Configures GitHub App integration with organization and installation ID",
    "Sets up GitLab group integration with access tokens and collaborator permissions",
    "Establishes Azure DevOps project integration with personal access tokens and agent pools"
  ],
  "inputs": [
    {
      "name": "np_api_key",
      "description": "Nullplatform API key for authentication.",
      "required": true
    },
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (NRN) — unique identifier for resources.",
      "required": true
    },
    {
      "name": "git_provider",
      "description": "Git provider to use (GitHub or GitLab).",
      "required": true
    },
    {
      "name": "gitlab_group_path",
      "description": "GitLab group path where repositories will be created.",
      "required": false
    },
    {
      "name": "gitlab_access_token",
      "description": "Access token for authenticating with the Git provider API.",
      "required": false
    },
    {
      "name": "gitlab_installation_url",
      "description": "Installation URL for the Git provider integration.",
      "required": false
    },
    {
      "name": "gitlab_collaborators_config",
      "description": "Configuration for repository collaborators, including their roles and permissions.",
      "required": false
    },
    {
      "name": "gitlab_repository_prefix",
      "description": "Prefix to use for GitLab repository names.",
      "required": false
    },
    {
      "name": "gitlab_slug",
      "description": "GitLab project slug identifier.",
      "required": false
    },
    {
      "name": "github_organization",
      "description": "GitHub organization name for repository creation.",
      "required": false
    },
    {
      "name": "github_installation_id",
      "description": "GitHub App installation ID for the organization.",
      "required": false
    },
    {
      "name": "azure_project",
      "description": "Azure devops project name",
      "required": false
    },
    {
      "name": "azure_access_token",
      "description": "Azure devops personal access token",
      "required": false
    },
    {
      "name": "azure_agent_pool",
      "description": "Azure devops CI agent pool",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "8cdff4b9c171af15f9839c9a87b148ea"
}
END_AI_METADATA -->
