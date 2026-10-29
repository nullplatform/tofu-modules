# Module: code_repository

## Description

Configures a nullplatform provider integration for one of four supported Git providers (GitHub, GitLab, Azure DevOps, or Bitbucket) by creating a conditional nullplatform_provider_config resource

## Architecture

The module evaluates the git_provider input variable through four local booleans (is_gitlab, is_github, is_azure, is_bitbucket) and uses count-based conditional creation to instantiate exactly one nullplatform_provider_config resource. Each provider variant sets a distinct type string (gitlab-configuration, github-configuration, azure-devops-configuration, or bitbucket) and serializes provider-specific credentials and settings into a jsonencode attributes block. The nrn input is transformed per-provider: GitLab optionally strips the namespace segment based on gitlab_keep_namespace, while GitHub, Azure, and Bitbucket always strip it via regex replace. An optional dimensions map allows segmentation of the resulting provider config across environments or regions.

## Features

- Creates a GitLab provider config with group path, access token, and installation URL attributes
- Creates a GitHub provider config with organization name and App installation ID
- Creates an Azure DevOps provider config with project name, personal access token, and CI agent pool
- Creates a Bitbucket provider config with workspace, project key, installation URL, and collaborator access list
- Supports optional namespace scoping for GitLab via the gitlab_keep_namespace flag
- Applies optional dimension segmentation to all provider configurations for environment or region partitioning
- Enforces provider-specific required variables at plan time using cross-variable Terraform validations

## Basic Usage

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v9.7.0"

  git_provider = "your-git-provider"
  nrn          = "your-nrn"
}
```

### Usage with GitHub Integration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v9.7.0"

  git_provider           = "github"
  github_installation_id = "your-github-installation-id"  # Required when git_provider = "github"
  github_organization    = "your-github-organization"  # Required when git_provider = "github"
  nrn                    = "your-nrn"
}
```

### Usage with GitLab Integration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v9.7.0"

  git_provider             = "gitlab"
  gitlab_access_token      = "your-gitlab-access-token"  # Required when git_provider = "gitlab"
  gitlab_group_path        = "your-gitlab-group-path"  # Required when git_provider = "gitlab"
  gitlab_installation_url  = "your-gitlab-installation-url"  # Required when git_provider = "gitlab"
  gitlab_repository_prefix = "your-gitlab-repository-prefix"  # Required when git_provider = "gitlab"
  gitlab_slug              = "your-gitlab-slug"  # Required when git_provider = "gitlab"
  nrn                      = "your-nrn"
}
```

### Usage with Azure DevOps Integration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v9.7.0"

  azure_access_token = "your-azure-access-token"  # Required when git_provider = "azure"
  azure_agent_pool   = "your-azure-agent-pool"  # Required when git_provider = "azure"
  azure_project      = "your-azure-project"  # Required when git_provider = "azure"
  git_provider       = "azure"
  nrn                = "your-nrn"
}
```

### Usage with Bitbucket Integration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v9.7.0"

  bitbucket_collaborators    = "your-bitbucket-collaborators"  # Required when git_provider = "bitbucket"
  bitbucket_installation_url = "your-bitbucket-installation-url"  # Required when git_provider = "bitbucket"
  bitbucket_project_key      = "your-bitbucket-project-key"  # Required when git_provider = "bitbucket"
  bitbucket_workspace        = "your-bitbucket-workspace"  # Required when git_provider = "bitbucket"
  git_provider               = "bitbucket"
  nrn                        = "your-nrn"
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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.azure](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |
| [nullplatform_provider_config.bitbucket](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |
| [nullplatform_provider_config.github](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |
| [nullplatform_provider_config.gitlab](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_access_token"></a> [azure\_access\_token](#input\_azure\_access\_token) | Azure devops personal access token | `string` | `null` | no |
| <a name="input_azure_agent_pool"></a> [azure\_agent\_pool](#input\_azure\_agent\_pool) | Azure devops CI agent pool | `string` | `"Default"` | no |
| <a name="input_azure_project"></a> [azure\_project](#input\_azure\_project) | Azure devops project name | `string` | `null` | no |
| <a name="input_bitbucket_collaborators"></a> [bitbucket\_collaborators](#input\_bitbucket\_collaborators) | Collaborators to grant repository access to. Each entry has an id, a role and a type. Only for git\_provider = "bitbucket". | <pre>list(object({<br/>    id   = string<br/>    role = string<br/>    type = string<br/>  }))</pre> | `[]` | no |
| <a name="input_bitbucket_installation_url"></a> [bitbucket\_installation\_url](#input\_bitbucket\_installation\_url) | Base URL for the Bitbucket integration. Only for git\_provider = "bitbucket"; leave unset for Bitbucket Cloud (https://bitbucket.org). | `string` | `null` | no |
| <a name="input_bitbucket_project_key"></a> [bitbucket\_project\_key](#input\_bitbucket\_project\_key) | Bitbucket project key under which repositories are created. Only for git\_provider = "bitbucket". | `string` | `null` | no |
| <a name="input_bitbucket_workspace"></a> [bitbucket\_workspace](#input\_bitbucket\_workspace) | Bitbucket workspace that owns the repositories. Only for git\_provider = "bitbucket". | `string` | `null` | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions to segment the nullplatform provider config (e.g. by region, environment) | `map(string)` | `{}` | no |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | Git provider to use (GitHub, GitLab, Azure DevOps or Bitbucket). | `string` | n/a | yes |
| <a name="input_github_installation_id"></a> [github\_installation\_id](#input\_github\_installation\_id) | GitHub App installation ID for the organization. | `string` | `null` | no |
| <a name="input_github_organization"></a> [github\_organization](#input\_github\_organization) | GitHub organization name for repository creation. | `string` | `null` | no |
| <a name="input_gitlab_access_token"></a> [gitlab\_access\_token](#input\_gitlab\_access\_token) | Access token for authenticating with the Git provider API. | `string` | `null` | no |
| <a name="input_gitlab_group_path"></a> [gitlab\_group\_path](#input\_gitlab\_group\_path) | GitLab group path where repositories will be created. | `string` | `null` | no |
| <a name="input_gitlab_installation_url"></a> [gitlab\_installation\_url](#input\_gitlab\_installation\_url) | Installation URL for the Git provider integration. | `string` | `null` | no |
| <a name="input_gitlab_keep_namespace"></a> [gitlab\_keep\_namespace](#input\_gitlab\_keep\_namespace) | Create the GitLab configuration at var.nrn as given. By default a namespace in var.nrn is stripped and the configuration lands at the account; set true to scope it to that namespace, as the other providers already are. | `bool` | `false` | no |
| <a name="input_gitlab_repository_prefix"></a> [gitlab\_repository\_prefix](#input\_gitlab\_repository\_prefix) | Prefix to use for GitLab repository names. | `string` | `null` | no |
| <a name="input_gitlab_slug"></a> [gitlab\_slug](#input\_gitlab\_slug) | GitLab project slug identifier. | `string` | `null` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (NRN) — unique identifier for resources. | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "code_repository",
  "description": "Configures a nullplatform provider integration for one of four supported Git providers (GitHub, GitLab, Azure DevOps, or Bitbucket) by creating a conditional nullplatform_provider_config resource",
  "architecture": "The module evaluates the git_provider input variable through four local booleans (is_gitlab, is_github, is_azure, is_bitbucket) and uses count-based conditional creation to instantiate exactly one nullplatform_provider_config resource. Each provider variant sets a distinct type string (gitlab-configuration, github-configuration, azure-devops-configuration, or bitbucket) and serializes provider-specific credentials and settings into a jsonencode attributes block. The nrn input is transformed per-provider: GitLab optionally strips the namespace segment based on gitlab_keep_namespace, while GitHub, Azure, and Bitbucket always strip it via regex replace. An optional dimensions map allows segmentation of the resulting provider config across environments or regions.",
  "features": [
    "Creates a GitLab provider config with group path, access token, and installation URL attributes",
    "Creates a GitHub provider config with organization name and App installation ID",
    "Creates an Azure DevOps provider config with project name, personal access token, and CI agent pool",
    "Creates a Bitbucket provider config with workspace, project key, installation URL, and collaborator access list",
    "Supports optional namespace scoping for GitLab via the gitlab_keep_namespace flag",
    "Applies optional dimension segmentation to all provider configurations for environment or region partitioning",
    "Enforces provider-specific required variables at plan time using cross-variable Terraform validations"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (NRN) — unique identifier for resources.",
      "required": true
    },
    {
      "name": "git_provider",
      "description": "Git provider to use (GitHub, GitLab, Azure DevOps or Bitbucket).",
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
      "name": "bitbucket_workspace",
      "description": "Bitbucket workspace that owns the repositories. Only for git_provider = \\",
      "required": false
    },
    {
      "name": "bitbucket_project_key",
      "description": "Bitbucket project key under which repositories are created. Only for git_provider = \\",
      "required": false
    },
    {
      "name": "bitbucket_installation_url",
      "description": "Base URL for the Bitbucket integration. Only for git_provider = \\",
      "required": false
    },
    {
      "name": "bitbucket_collaborators",
      "description": "Collaborators to grant repository access to. Each entry has an id, a role and a type. Only for git_provider = \\",
      "required": false
    },
    {
      "name": "gitlab_keep_namespace",
      "description": "Create the GitLab configuration at var.nrn as given. By default a namespace in var.nrn is stripped and the configuration lands at the account; set true to scope it to that namespace, as the other providers already are.",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Dimensions to segment the nullplatform provider config (e.g. by region, environment)",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "ee4407021de6fcb79537d9defa9902b9"
}
END_AI_METADATA -->
