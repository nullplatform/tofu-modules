# Module: service_definition

## Description

Creates a Nullplatform service specification with associated action and link specifications by fetching JSON templates from GitHub, GitLab, or a local filesystem path

## Architecture

The module fetches service, action, and link spec templates via the `http` data source from GitHub raw content URLs or GitLab API v4 file endpoints (or reads them from local disk when git_provider is 'local'). The parsed JSON templates are fed into a `nullplatform_service_specification` resource, which is then referenced by `nullplatform_action_specification` and `nullplatform_link_specification` resources created via for_each loops over the available_actions and available_links lists. Authentication headers are conditionally set based on the git_provider value and an optional repository_token, and all created specifications expose their ID and slug as outputs.

## Features

- Creates a nullplatform_service_specification resource populated from a JSON template fetched remotely or read locally
- Creates nullplatform_action_specification resources for each action template listed in available_actions
- Creates nullplatform_link_specification resources for each link template listed in available_links
- Fetches spec templates from GitHub using raw content URLs with optional Bearer token authentication
- Fetches spec templates from GitLab using API v4 file endpoints with URL-encoded paths and optional PAT authentication
- Supports local filesystem spec loading for offline or development workflows via a configurable local path
- Controls service specification visibility by merging the primary NRN with additional NRNs via extra_visibile_to_nrns

## Basic Usage

```hcl
module "service_definition" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/service_definition?ref=v4.6.0"

  nrn          = "your-nrn"
  service_name = "your-service-name"
  service_path = "your-service-path"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.service_definition.service_specification_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_http"></a> [http](#requirement\_http) | ~> 3.0 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | >= 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | 3.5.0 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.86 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_action_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/action_specification) | resource |
| [nullplatform_link_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/link_specification) | resource |
| [nullplatform_service_specification.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/service_specification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_available_actions"></a> [available\_actions](#input\_available\_actions) | List of action template names to fetch from the service spec repository | `list(string)` | `[]` | no |
| <a name="input_available_links"></a> [available\_links](#input\_available\_links) | List of link template names to fetch from the service spec repository | `list(string)` | <pre>[<br/>  "connect"<br/>]</pre> | no |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Key-value pairs for dimensions to be associated with the service specification | `map(string)` | `{}` | no |
| <a name="input_extra_visibile_to_nrns"></a> [extra\_visibile\_to\_nrns](#input\_extra\_visibile\_to\_nrns) | Additional NRNs that should have visibility to the created service specification | `list(string)` | `[]` | no |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | Git provider to fetch service specs from. Supported values: "github", "gitlab", "local". | `string` | `"github"` | no |
| <a name="input_gitlab_host"></a> [gitlab\_host](#input\_gitlab\_host) | GitLab host. Only used when git\_provider = "gitlab". Override for self-hosted instances (e.g. "gitlab.mycompany.com"). | `string` | `"gitlab.com"` | no |
| <a name="input_local_specs_path"></a> [local\_specs\_path](#input\_local\_specs\_path) | Absolute path to the local service directory containing specs/. Required when git\_provider = "local". The directory must contain specs/service-spec.json.tpl and optionally specs/links/*.json.tpl and specs/actions/*.json.tpl. | `string` | `null` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | n/a | yes |
| <a name="input_repository_branch"></a> [repository\_branch](#input\_repository\_branch) | Branch of the service spec repository to use. Must be a short branch name (e.g. "main"), not a full ref. | `string` | `"main"` | no |
| <a name="input_repository_name"></a> [repository\_name](#input\_repository\_name) | Repository name containing the service spec templates. | `string` | `"service"` | no |
| <a name="input_repository_org"></a> [repository\_org](#input\_repository\_org) | GitHub organization or GitLab group owning the service spec repository. | `string` | `"nullplatform"` | no |
| <a name="input_repository_token"></a> [repository\_token](#input\_repository\_token) | Access token for private repositories. GitHub: personal access token or fine-grained token. GitLab: Personal Access Token (PAT) with read\_api scope. | `string` | `null` | no |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the scope type to be created | `string` | n/a | yes |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path within the repository for the specific service (e.g., databases/postgres/k8s) | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | The ID of the created service specification |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | The slug of the created service specification |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "service_definition",
  "description": "Creates a Nullplatform service specification with associated action and link specifications by fetching JSON templates from GitHub, GitLab, or a local filesystem path",
  "architecture": "The module fetches service, action, and link spec templates via the `http` data source from GitHub raw content URLs or GitLab API v4 file endpoints (or reads them from local disk when git_provider is 'local'). The parsed JSON templates are fed into a `nullplatform_service_specification` resource, which is then referenced by `nullplatform_action_specification` and `nullplatform_link_specification` resources created via for_each loops over the available_actions and available_links lists. Authentication headers are conditionally set based on the git_provider value and an optional repository_token, and all created specifications expose their ID and slug as outputs.",
  "features": [
    "Creates a nullplatform_service_specification resource populated from a JSON template fetched remotely or read locally",
    "Creates nullplatform_action_specification resources for each action template listed in available_actions",
    "Creates nullplatform_link_specification resources for each link template listed in available_links",
    "Fetches spec templates from GitHub using raw content URLs with optional Bearer token authentication",
    "Fetches spec templates from GitLab using API v4 file endpoints with URL-encoded paths and optional PAT authentication",
    "Supports local filesystem spec loading for offline or development workflows via a configurable local path",
    "Controls service specification visibility by merging the primary NRN with additional NRNs via extra_visibile_to_nrns"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform Resource Name (organization:account format)",
      "required": true
    },
    {
      "name": "service_path",
      "description": "Path within the repository for the specific service (e.g., databases/postgres/k8s)",
      "required": true
    },
    {
      "name": "service_name",
      "description": "Name of the scope type to be created",
      "required": true
    },
    {
      "name": "git_provider",
      "description": "Git provider to fetch service specs from. Supported values: \\",
      "required": false
    },
    {
      "name": "local_specs_path",
      "description": "Absolute path to the local service directory containing specs/. Required when git_provider = \\",
      "required": false
    },
    {
      "name": "repository_org",
      "description": "GitHub organization or GitLab group owning the service spec repository.",
      "required": false
    },
    {
      "name": "repository_name",
      "description": "Repository name containing the service spec templates.",
      "required": false
    },
    {
      "name": "repository_branch",
      "description": "Branch of the service spec repository to use. Must be a short branch name (e.g. \\",
      "required": false
    },
    {
      "name": "available_actions",
      "description": "List of action template names to fetch from the service spec repository",
      "required": false
    },
    {
      "name": "available_links",
      "description": "List of link template names to fetch from the service spec repository",
      "required": false
    },
    {
      "name": "repository_token",
      "description": "Access token for private repositories. GitHub: personal access token or fine-grained token. GitLab: Personal Access Token (PAT) with read_api scope.",
      "required": false
    },
    {
      "name": "gitlab_host",
      "description": "GitLab host. Only used when git_provider = \\",
      "required": false
    },
    {
      "name": "extra_visibile_to_nrns",
      "description": "Additional NRNs that should have visibility to the created service specification",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Key-value pairs for dimensions to be associated with the service specification",
      "required": false
    }
  ],
  "outputs": [
    "service_specification_id",
    "service_specification_slug"
  ],
  "hash": "d2c5d76a9178fb0ffc8aaaff485fa6c1"
}
END_AI_METADATA -->
