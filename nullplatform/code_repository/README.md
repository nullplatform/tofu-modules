# Module: code_repository

## Description

Configures Git provider integration for Nullplatform with support for GitHub, GitLab, and Azure DevOps

## Architecture

The module creates a nullplatform_provider_config resource conditionally based on the git_provider variable. For GitLab, it provisions a gitlab-configuration resource with group path, access token, installation URL, and collaborators. For GitHub, it creates a github-configuration resource with organization name and installation ID. For Azure DevOps, it provisions an azure-devops-configuration resource with project name, access token, and agent pool. The nrn variable flows into each resource after regex transformation or replacement to remove namespace suffixes, while dimensions map directly to resource attributes.

## Features

- Creates nullplatform_provider_config resource for GitHub with organization and installation ID
- Creates nullplatform_provider_config resource for GitLab with group path, access tokens, and collaborator configuration
- Creates nullplatform_provider_config resource for Azure DevOps with project, access token, and agent pool settings
- Supports dimensional segmentation of provider configurations by region or environment
- Manages NRN transformation with regex-based namespace extraction for GitLab and replacement for other providers
- Implements lifecycle ignore_changes for attributes to prevent drift detection on external modifications

## Basic Usage

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v4.0.0"

  git_provider = "your-git-provider"
  nrn          = "your-nrn"
}
```

### Usage with GitHub Configuration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v4.0.0"

  git_provider           = "github"
  github_installation_id = "your-github-installation-id"  # Required when git_provider = "github"
  github_organization    = "your-github-organization"  # Required when git_provider = "github"
  nrn                    = "your-nrn"
}
```

### Usage with GitLab Configuration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v4.0.0"

  git_provider                = "gitlab"
  gitlab_access_token         = "your-gitlab-access-token"  # Required when git_provider = "gitlab"
  gitlab_collaborators_config = "your-gitlab-collaborators-config"  # Required when git_provider = "gitlab"
  gitlab_group_path           = "your-gitlab-group-path"  # Required when git_provider = "gitlab"
  gitlab_installation_url     = "your-gitlab-installation-url"  # Required when git_provider = "gitlab"
  gitlab_repository_prefix    = "your-gitlab-repository-prefix"  # Required when git_provider = "gitlab"
  gitlab_slug                 = "your-gitlab-slug"  # Required when git_provider = "gitlab"
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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.86 |

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
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions to segment the nullplatform provider config (e.g. by region, environment) | `map(string)` | `{}` | no |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | Git provider to use (GitHub or GitLab). | `string` | n/a | yes |
| <a name="input_github_installation_id"></a> [github\_installation\_id](#input\_github\_installation\_id) | GitHub App installation ID for the organization. | `string` | `null` | no |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | GitHub organization name for repository creation. | `string` | `null` | no |
| <a name="input_gitlab_access_token"></a> [gitlab\_access\_token](#input\_gitlab\_access\_token) | Access token for authenticating with the Git provider API. | `string` | `null` | no |
| <a name="input_gitlab_collaborators_config"></a> [gitlab\_collaborators\_config](#input\_gitlab\_collaborators\_config) | Configuration for repository collaborators, including their roles and permissions. | <pre>object({<br/>    collaborators = list(object({<br/>      id   = string<br/>      role = string<br/>      type = string<br/>    }))<br/>  })</pre> | `null` | no |
| <a name="input_gitlab_group_path"></a> [gitlab\_group\_path](#input\_gitlab\_group\_path) | GitLab group path where repositories will be created. | `string` | `null` | no |
| <a name="input_gitlab_installation_url"></a> [gitlab\_installation\_url](#input\_gitlab\_installation\_url) | Installation URL for the Git provider integration. | `string` | `null` | no |
| <a name="input_gitlab_repository_prefix"></a> [gitlab\_repository\_prefix](#input\_gitlab\_repository\_prefix) | Prefix to use for GitLab repository names. | `string` | `null` | no |
| <a name="input_gitlab_slug"></a> [gitlab\_slug](#input\_gitlab\_slug) | GitLab project slug identifier. | `string` | `null` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (NRN) — unique identifier for resources. | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "code_repository",
  "description": "Configures Git provider integration for Nullplatform with support for GitHub, GitLab, and Azure DevOps",
  "architecture": "The module creates a nullplatform_provider_config resource conditionally based on the git_provider variable. For GitLab, it provisions a gitlab-configuration resource with group path, access token, installation URL, and collaborators. For GitHub, it creates a github-configuration resource with organization name and installation ID. For Azure DevOps, it provisions an azure-devops-configuration resource with project name, access token, and agent pool. The nrn variable flows into each resource after regex transformation or replacement to remove namespace suffixes, while dimensions map directly to resource attributes.",
  "features": [
    "Creates nullplatform_provider_config resource for GitHub with organization and installation ID",
    "Creates nullplatform_provider_config resource for GitLab with group path, access tokens, and collaborator configuration",
    "Creates nullplatform_provider_config resource for Azure DevOps with project, access token, and agent pool settings",
    "Supports dimensional segmentation of provider configurations by region or environment",
    "Manages NRN transformation with regex-based namespace extraction for GitLab and replacement for other providers",
    "Implements lifecycle ignore_changes for attributes to prevent drift detection on external modifications"
  ],
  "inputs": [
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
    },
    {
      "name": "dimensions",
      "description": "Dimensions to segment the nullplatform provider config (e.g. by region, environment)",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "71216d11bb52f82d8d85bc7cede9a7da"
}
END_AI_METADATA -->
