## [ALPHA] Service-Definition module

## How to use it

```hcl
module "service_definition" {
    source = "git@github.com:nullplatform/main-terraform-modules.git//modules/nullplatform/service-definition"

    nrn                 = "organization:account"
    np_api_key          = "your-api-key"
    git_repo            = "nullplatform/services"
    git_ref             = "main"
    git_service_path    = "databases/postgres/k8s"
    service_name        = "PostgreSQL Database"
    service_description = "PostgreSQL database service running in Kubernetes"
    dimensions = {
        environment = "production"
        region      = "us-east-1"
    }
}
```

## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | n/a |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [nullplatform_action_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/action_specification) | resource |
| [nullplatform_link_specification.service_link_from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/link_specification) | resource |
| [nullplatform_service_specification.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/service_specification) | resource |
| [http_http.action_templates](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.link_templates](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.service_spec_template](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Key-value pairs for dimensions to be associated with the service specification | `map(string)` | `null` | no |
| <a name="input_extra_visibile_to_nrns"></a> [extra\_visibile\_to\_nrns](#input\_extra\_visibile\_to\_nrns) | Additional NRNs that should have visibility to the created service specification | `list(string)` | `[]` | no |
| <a name="input_git_password"></a> [git\_password](#input\_git\_password) | Git provider (e.g., github, gitlab) | `string` | `null` | no |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | Git provider (e.g., github, gitlab) | `string` | `"github"` | no |
| <a name="input_git_ref"></a> [git\_ref](#input\_git\_ref) | Git reference (branch, tag, or commit) | `string` | `"main"` | no |
| <a name="input_git_repo"></a> [git\_repo](#input\_git\_repo) | GitHub repository URL containing templates | `string` | `"nullplatform/services"` | no |
| <a name="input_git_service_path"></a> [git\_service\_path](#input\_git\_service\_path) | Path within the repository for the specific service (e.g., databases/postgres/k8s) | `string` | n/a | yes |
| <a name="input_git_user"></a> [git\_user](#input\_git\_user) | Git provider (e.g., github, gitlab) | `string` | `null` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | n/a | yes |
| <a name="input_service_description"></a> [service\_description](#input\_service\_description) | Description of the scope type to be created | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the scope type to be created | `string` | n/a | yes |
| <a name="input_use_tpl_files"></a> [use\_tpl\_files](#input\_use\_tpl\_files) | Whether to use .tpl files (true) or .json files (false) for templates | `bool` | `false` | no |
| <a name="input_workflow_override_path"></a> [workflow\_override\_path](#input\_workflow\_override\_path) | Path to a custom workflow file to override the default one | `string` | `""` | no |
| <a name="input_workflow_override_values"></a> [workflow\_override\_values](#input\_workflow\_override\_values) | Values to override in the workflow file | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_action_specification_ids"></a> [action\_specification\_ids](#output\_action\_specification\_ids) | Map of action specification names to their IDs |
| <a name="output_git_password"></a> [git\_password](#output\_git\_password) | The Git password associated with the service specification |
| <a name="output_git_provider"></a> [git\_provider](#output\_git\_provider) | The Git provider associated with the service specification |
| <a name="output_git_ref"></a> [git\_ref](#output\_git\_ref) | The GitHub branch associated with the service specification |
| <a name="output_git_repo"></a> [git\_repo](#output\_git\_repo) | The GitHub repository URL associated with the service specification |
| <a name="output_git_service_path"></a> [git\_service\_path](#output\_git\_service\_path) | The GitHub path associated with the service specification |
| <a name="output_git_user"></a> [git\_user](#output\_git\_user) | The Git user associated with the service specification |
| <a name="output_link_specification_ids"></a> [link\_specification\_ids](#output\_link\_specification\_ids) | Map of link specification names to their IDs |
| <a name="output_nrn"></a> [nrn](#output\_nrn) | The NRN of the created service specification |
| <a name="output_service_description"></a> [service\_description](#output\_service\_description) | The description of the service definition |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the scope definition |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | The ID of the created service specification |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | The slug of the created service specification |
| <a name="output_slug"></a> [slug](#output\_slug) | The slug of the created service specification |
| <a name="output_specification"></a> [specification](#output\_specification) | The attributes of the created service specification |
| <a name="output_workflow_override_path"></a> [workflow\_override\_path](#output\_workflow\_override\_path) | The path to the custom workflow file |
| <a name="output_workflow_override_values"></a> [workflow\_override\_values](#output\_workflow\_override\_values) | The workflow override values |
<!-- BEGIN_TF_DOCS -->


## Providers

| Name | Version |
|------|---------|
| <a name="provider_github"></a> [github](#provider\_github) | n/a |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | n/a |

## Resources

| Name | Type |
|------|------|
| [nullplatform_action_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/action_specification) | resource |
| [nullplatform_link_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/link_specification) | resource |
| [nullplatform_service_specification.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/service_specification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Key-value pairs for dimensions to be associated with the service specification | `map(string)` | `{}` | no |
| <a name="input_extra_visibile_to_nrns"></a> [extra\_visibile\_to\_nrns](#input\_extra\_visibile\_to\_nrns) | Additional NRNs that should have visibility to the created service specification | `list(string)` | `[]` | no |
| <a name="input_git_password"></a> [git\_password](#input\_git\_password) | Git provider (e.g., github, gitlab) | `string` | `null` | no |
| <a name="input_git_provider"></a> [git\_provider](#input\_git\_provider) | Git provider (e.g., github, gitlab) | `string` | `"github"` | no |
| <a name="input_git_ref"></a> [git\_ref](#input\_git\_ref) | Git reference (branch, tag, or commit) | `string` | `"main"` | no |
| <a name="input_git_repo"></a> [git\_repo](#input\_git\_repo) | GitHub repository URL containing templates | `string` | `"nullplatform/services"` | no |
| <a name="input_git_service_path"></a> [git\_service\_path](#input\_git\_service\_path) | Path within the repository for the specific service (e.g., databases/postgres/k8s) | `string` | n/a | yes |
| <a name="input_git_user"></a> [git\_user](#input\_git\_user) | Git provider (e.g., github, gitlab) | `string` | `null` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | n/a | yes |
| <a name="input_service_description"></a> [service\_description](#input\_service\_description) | Description of the scope type to be created | `string` | n/a | yes |
| <a name="input_service_name"></a> [service\_name](#input\_service\_name) | Name of the scope type to be created | `string` | n/a | yes |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter agents | `map(string)` | `{}` | no |
| <a name="input_use_tpl_files"></a> [use\_tpl\_files](#input\_use\_tpl\_files) | Whether to use .tpl files (true) or .json files (false) for templates | `bool` | `false` | no |
| <a name="input_workflow_override_path"></a> [workflow\_override\_path](#input\_workflow\_override\_path) | Path to a custom workflow file to override the default one | `string` | `null` | no |
| <a name="input_workflow_override_values"></a> [workflow\_override\_values](#input\_workflow\_override\_values) | Values to override in the workflow file | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_action_specification_ids"></a> [action\_specification\_ids](#output\_action\_specification\_ids) | Map of action specification names to their IDs |
| <a name="output_git_password"></a> [git\_password](#output\_git\_password) | The Git password associated with the service specification |
| <a name="output_git_provider"></a> [git\_provider](#output\_git\_provider) | The Git provider associated with the service specification |
| <a name="output_git_ref"></a> [git\_ref](#output\_git\_ref) | The GitHub branch associated with the service specification |
| <a name="output_git_repo"></a> [git\_repo](#output\_git\_repo) | The GitHub repository URL associated with the service specification |
| <a name="output_git_service_path"></a> [git\_service\_path](#output\_git\_service\_path) | The GitHub path associated with the service specification |
| <a name="output_git_user"></a> [git\_user](#output\_git\_user) | The Git user associated with the service specification |
| <a name="output_link_specification_ids"></a> [link\_specification\_ids](#output\_link\_specification\_ids) | Map of link specification names to their IDs |
| <a name="output_nrn"></a> [nrn](#output\_nrn) | The NRN of the created service specification |
| <a name="output_service_description"></a> [service\_description](#output\_service\_description) | The description of the service definition |
| <a name="output_service_name"></a> [service\_name](#output\_service\_name) | The name of the scope definition |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | The ID of the created service specification |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | The slug of the created service specification |
| <a name="output_slug"></a> [slug](#output\_slug) | The slug of the created service specification |
| <a name="output_specification"></a> [specification](#output\_specification) | The attributes of the created service specification |
| <a name="output_workflow_override_path"></a> [workflow\_override\_path](#output\_workflow\_override\_path) | The path to the custom workflow file |
| <a name="output_workflow_override_values"></a> [workflow\_override\_values](#output\_workflow\_override\_values) | The workflow override values |
<!-- END_TF_DOCS -->