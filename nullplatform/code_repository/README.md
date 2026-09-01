# Module: code_repository

## Description

Configures a nullplatform git provider integration by creating a nullplatform_provider_config resource for one of four supported providers: GitHub, GitLab, Azure DevOps, or Bitbucket

## Architecture

The module uses local boolean flags (is_gitlab, is_github, is_azure, is_bitbucket) derived from var.git_provider to conditionally create exactly one nullplatform_provider_config resource via count = local.is_X ? 1 : 0. Each nullplatform_provider_config resource is bound to a scoped NRN (namespace-stripped via regex or replace), a provider-specific type string (e.g. gitlab-configuration, github-configuration, azure-devops-configuration, bitbucket), and a JSON-encoded attributes block containing provider-specific setup credentials and configuration. The dimensions input flows directly into every resource to support multi-environment or multi-region segmentation within the nullplatform platform.

## Features

- Creates a nullplatform_provider_config resource with GitLab-specific setup including group path, access token, and installation URL
- Creates a nullplatform_provider_config resource with GitHub-specific setup including organization name and App installation ID
- Creates a nullplatform_provider_config resource with Azure DevOps setup including project name, personal access token, and CI agent pool
- Creates a nullplatform_provider_config resource with Bitbucket setup including workspace, project key, installation URL, and collaborator access list
- Enforces provider-specific required variables at plan time using Terraform validation blocks tied to the git_provider selector
- Supports dimensional segmentation of provider configs via a flexible map of key-value dimension labels
- Strips namespace scope from the NRN automatically to ensure provider configs are registered at the correct platform hierarchy level

## Basic Usage

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v6.22.1"

  git_provider = "your-git-provider"
  nrn          = "your-nrn"
}
```

### Usage with GitHub Integration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v6.22.1"

  git_provider           = "github"
  github_installation_id = "your-github-installation-id"  # Required when git_provider = "github"
  github_organization    = "your-github-organization"  # Required when git_provider = "github"
  nrn                    = "your-nrn"
}
```

### Usage with GitLab Integration

```hcl
module "code_repository" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v6.22.1"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v6.22.1"

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
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v6.22.1"

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
| <a name="input_gitlab_repository_prefix"></a> [gitlab\_repository\_prefix](#input\_gitlab\_repository\_prefix) | Prefix to use for GitLab repository names. | `string` | `null` | no |
| <a name="input_gitlab_slug"></a> [gitlab\_slug](#input\_gitlab\_slug) | GitLab project slug identifier. | `string` | `null` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (NRN) — unique identifier for resources. | `string` | n/a | yes |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "code_repository",
  "description": "Configures a nullplatform git provider integration by creating a nullplatform_provider_config resource for one of four supported providers: GitHub, GitLab, Azure DevOps, or Bitbucket",
  "architecture": "The module uses local boolean flags (is_gitlab, is_github, is_azure, is_bitbucket) derived from var.git_provider to conditionally create exactly one nullplatform_provider_config resource via count = local.is_X ? 1 : 0. Each nullplatform_provider_config resource is bound to a scoped NRN (namespace-stripped via regex or replace), a provider-specific type string (e.g. gitlab-configuration, github-configuration, azure-devops-configuration, bitbucket), and a JSON-encoded attributes block containing provider-specific setup credentials and configuration. The dimensions input flows directly into every resource to support multi-environment or multi-region segmentation within the nullplatform platform.",
  "features": [
    "Creates a nullplatform_provider_config resource with GitLab-specific setup including group path, access token, and installation URL",
    "Creates a nullplatform_provider_config resource with GitHub-specific setup including organization name and App installation ID",
    "Creates a nullplatform_provider_config resource with Azure DevOps setup including project name, personal access token, and CI agent pool",
    "Creates a nullplatform_provider_config resource with Bitbucket setup including workspace, project key, installation URL, and collaborator access list",
    "Enforces provider-specific required variables at plan time using Terraform validation blocks tied to the git_provider selector",
    "Supports dimensional segmentation of provider configs via a flexible map of key-value dimension labels",
    "Strips namespace scope from the NRN automatically to ensure provider configs are registered at the correct platform hierarchy level"
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
      "name": "dimensions",
      "description": "Dimensions to segment the nullplatform provider config (e.g. by region, environment)",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "78d2c8b0829524bd28615a692ff9331c"
}
END_AI_METADATA -->
