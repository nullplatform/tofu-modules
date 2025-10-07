## [ALPHA] Scope-Definition module

## How to use it

```hcl
module "" {
    source = "git@github.com:nullplatform/main-terraform-modules.git//modules/nullplatform/scope-definition"

    nrn        = ""
    np_api_key = ""
    github_repo_url = "https://github.com/nullplatform/scopes"
    github_ref      = "main"
    github_scope_path = "k8s"
    scope_name        = "K8S Webserver"
    scope_description = "Webserver running in a Kubernetes cluster"
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
| [nullplatform_scope_type.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/scope_type) | resource |
| [nullplatform_service_specification.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/service_specification) | resource |
| [http_http.action_templates](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |
| [http_http.service_spec_template](https://registry.terraform.io/providers/hashicorp/http/latest/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_spec_names"></a> [action\_spec\_names](#input\_action\_spec\_names) | List of action specification template names to fetch and create | `list(string)` | <pre>[<br/>  "create-scope",<br/>  "delete-scope",<br/>  "start-initial",<br/>  "start-blue-green",<br/>  "finalize-blue-green",<br/>  "rollback-deployment",<br/>  "delete-deployment",<br/>  "switch-traffic",<br/>  "set-desired-instance-count",<br/>  "pause-autoscaling",<br/>  "resume-autoscaling",<br/>  "restart-pods",<br/>  "kill-instances"<br/>]</pre> | no |
| <a name="input_github_ref"></a> [github\_ref](#input\_github\_ref) | Git reference (branch, tag, or commit) | `string` | `"main"` | no |
| <a name="input_github_repo_url"></a> [github\_repo\_url](#input\_github\_repo\_url) | GitHub repository URL containing templates | `string` | `"https://github.com/nullplatform/scopes"` | no |
| <a name="input_github_scope_path"></a> [github\_scope\_path](#input\_github\_scope\_path) | Path within the repository for the specific scope (e.g., k8s, ecs) | `string` | `"k8s"` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name (organization:account format) | `string` | n/a | yes |
| <a name="input_scope_description"></a> [scope\_description](#input\_scope\_description) | Description of the scope type to be created | `string` | n/a | yes |
| <a name="input_scope_name"></a> [scope\_name](#input\_scope\_name) | Name of the scope type to be created | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_action_specification_ids"></a> [action\_specification\_ids](#output\_action\_specification\_ids) | Map of action specification names to their IDs |
| <a name="output_scope_type_id"></a> [scope\_type\_id](#output\_scope\_type\_id) | The ID of the created scope type |
| <a name="output_service_specification_id"></a> [service\_specification\_id](#output\_service\_specification\_id) | The ID of the created service specification |
| <a name="output_service_specification_slug"></a> [service\_specification\_slug](#output\_service\_specification\_slug) | The slug of the created service specification |