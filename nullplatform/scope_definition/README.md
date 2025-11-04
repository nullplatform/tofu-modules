
# Module: Scope Definition

This Terraform module clones a Git repository containing service and action specification templates, processes those templates using gomplate to inject dynamic variables, and then creates corresponding nullplatform resources (service, scope type, and actions). It also patches the target NRN with logging and metrics providers and cleans up the cloned repository after execution

Usage:

```
module "scope_definition" {
  source               = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition?ref=v1.0.0"
  nrn                  = local.nrn_without_namespace
  np_api_key           = var.np_api_key
```


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_external"></a> [external](#requirement\_external) | ~> 2.3.5 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2.4 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | ~> 2.3.5 |
| <a name="provider_local"></a> [local](#provider\_local) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | ~> 3.2.4 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [null_resource.cleanup_repo](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.clone_repo](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [null_resource.nrn_patch](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [nullplatform_action_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/action_specification) | resource |
| [nullplatform_scope_type.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/scope_type) | resource |
| [nullplatform_service_specification.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/service_specification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_spec_names"></a> [action\_spec\_names](#input\_action\_spec\_names) | List of action specification template names to fetch and create for scope operations. | `list(string)` | <pre>[<br/>  "create-scope",<br/>  "delete-scope",<br/>  "start-initial",<br/>  "start-blue-green",<br/>  "finalize-blue-green",<br/>  "rollback-deployment",<br/>  "delete-deployment",<br/>  "switch-traffic",<br/>  "set-desired-instance-count",<br/>  "pause-autoscaling",<br/>  "resume-autoscaling",<br/>  "restart-pods",<br/>  "kill-instances"<br/>]</pre> | no |
| <a name="input_external_logging_provider"></a> [external\_logging\_provider](#input\_external\_logging\_provider) | Name of the external log provider (e.g., 'cloudwatch', 'elastic'). | `string` | `"cloudwatch"` | no |
| <a name="input_external_metrics_provider"></a> [external\_metrics\_provider](#input\_external\_metrics\_provider) | Name of the external metrics provider for monitoring integration. | `string` | `"externalmetrics"` | no |
| <a name="input_github_ref"></a> [github\_ref](#input\_github\_ref) | Branch, tag, or commit SHA of the Git repository to read templates from. | `string` | `"beta"` | no |
| <a name="input_github_repo_name"></a> [github\_repo\_name](#input\_github\_repo\_name) | Name of the GitHub repository in 'owner/repo' format (e.g., 'nullplatform/service-definitions'). | `string` | `"nullplatform/scopes"` | no |
| <a name="input_github_repo_url"></a> [github\_repo\_url](#input\_github\_repo\_url) | Git repository URL (HTTPS or SSH format) used to clone the templates. | `string` | `"https://github.com/nullplatform/scopes.git"` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key used for executing local commands (e.g., 'np nrn patch'). | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Unique NRN identifier of the environment or resource in Nullplatform. | `string` | n/a | yes |
| <a name="input_repo_path"></a> [repo\_path](#input\_repo\_path) | Base path to the repository used as context for gomplate template rendering. | `string` | `"/root/.np/nullplatform/scopes"` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Path within the repository where the service specification files are stored (e.g., 'services/api'). | `string` | `"k8s"` | no |
| <a name="input_service_spec_description"></a> [service\_spec\_description](#input\_service\_spec\_description) | Description of the created service or associated scope type. | `string` | `"Docker containers on pods"` | no |
| <a name="input_service_spec_name"></a> [service\_spec\_name](#input\_service\_spec\_name) | Name of the service that will be created from the specification template. | `string` | `"Containers"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_actions_created"></a> [actions\_created](#output\_actions\_created) | Map of all action specifications created from templates. |
| <a name="output_scope_type_id"></a> [scope\_type\_id](#output\_scope\_type\_id) | ID of the scope type created from the template. |
| <a name="output_service_slug"></a> [service\_slug](#output\_service\_slug) | Slug (unique name) of the service specification created in Nullplatform. |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | ID of the service specification created in Nullplatform. |
<!-- END_TF_DOCS -->

