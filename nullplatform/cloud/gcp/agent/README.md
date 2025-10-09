# Module: GCP Agent

Deploys the Nullplatform agent Helm chart, issues an agent API key, and syncs service, scope, and action specifications from the provided templates.

Usage:

```
module "cloud_gcp_agent" {
  source            = "git@github.com:nullplatform/tofu-modules.git//nullplatform/cloud/gcp/agent?ref=v0.0.1"
  cluster_name      = var.cluster_name
  nrn               = var.nrn
  np_api_key        = var.np_api_key
  environment_tag   = var.environment_tag
  tags              = var.tags
  namespace         = var.namespace
  agent_repos_scope = var.agent_repos_scope
  agent_repos_extra = var.agent_repos_extra
  github_repo_url   = var.github_repo_url
  github_ref        = var.github_ref
  init_scripts      = var.init_scripts
  kubeconfig_path   = var.kubeconfig_path
  kube_context      = var.kube_context
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_helm"></a> [helm](#requirement\_helm) | ~> 3.0 |
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_external"></a> [external](#provider\_external) | n/a |
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_http"></a> [http](#provider\_http) | n/a |
| <a name="provider_null"></a> [null](#provider\_null) | n/a |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [helm_release.agent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [null_resource.nrn_patch](https://registry.terraform.io/providers/hashicorp/null/latest/docs/resources/resource) | resource |
| [nullplatform_action_specification.from_templates](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/action_specification) | resource |
| [nullplatform_api_key.nullplatform_agent_api_key](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/api_key) | resource |
| [nullplatform_notification_channel.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/notification_channel) | resource |
| [nullplatform_scope_type.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/scope_type) | resource |
| [nullplatform_service_specification.from_template](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/service_specification) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_action_spec_names"></a> [action\_spec\_names](#input\_action\_spec\_names) | List of action specification template names to fetch and create | `list(string)` | <pre>[<br/>  "create-scope",<br/>  "delete-scope",<br/>  "start-initial",<br/>  "start-blue-green",<br/>  "finalize-blue-green",<br/>  "rollback-deployment",<br/>  "delete-deployment",<br/>  "switch-traffic",<br/>  "set-desired-instance-count",<br/>  "pause-autoscaling",<br/>  "resume-autoscaling",<br/>  "restart-pods",<br/>  "kill-instances"<br/>]</pre> | no |
| <a name="input_agent_repos_extra"></a> [agent\_repos\_extra](#input\_agent\_repos\_extra) | Additional repositories for the agent configuration | `list(string)` | `[]` | no |
| <a name="input_agent_repos_scope"></a> [agent\_repos\_scope](#input\_agent\_repos\_scope) | Git repository URL for agent scopes configuration | `string` | `"https://github.com/nullplatform/scopes.git#ftc"` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the kubernetes cluster | `string` | n/a | yes |
| <a name="input_environment_tag"></a> [environment\_tag](#input\_environment\_tag) | Environment tag to identify and filter agent resources | `string` | n/a | yes |
| <a name="input_external_logging_provider"></a> [external\_logging\_provider](#input\_external\_logging\_provider) | External logging provider name | `string` | `"external"` | no |
| <a name="input_external_metrics_provider"></a> [external\_metrics\_provider](#input\_external\_metrics\_provider) | External metrics provider name | `string` | `"externalmetrics"` | no |
| <a name="input_github_ref"></a> [github\_ref](#input\_github\_ref) | Git reference (branch, tag, or commit) | `string` | `"ftc"` | no |
| <a name="input_github_repo_url"></a> [github\_repo\_url](#input\_github\_repo\_url) | GitHub repository URL containing templates | `string` | `"https://github.com/nullplatform/scopes"` | no |
| <a name="input_init_scripts"></a> [init\_scripts](#input\_init\_scripts) | List of initialization scripts to run | `list(string)` | `[]` | no |
| <a name="input_kube_context"></a> [kube\_context](#input\_kube\_context) | Kubernetes context name to use from the kubeconfig file | `string` | `null` | no |
| <a name="input_kubeconfig_path"></a> [kubeconfig\_path](#input\_kubeconfig\_path) | Path to the kubeconfig file for Kubernetes cluster access | `string` | `"~/.kube/config"` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace to agent run | `string` | `"nullplatform-tools"` | no |
| <a name="input_np_api_key"></a> [np\_api\_key](#input\_np\_api\_key) | Nullplatform API key for authentication | `string` | n/a | yes |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Identifier Nullplatform Resources Name | `string` | n/a | yes |
| <a name="input_nullplatform_agent_helm_version"></a> [nullplatform_agent_helm_version](#input\_nullplatform_agent_helm_version) | Helm chart version for the Nullplatform agent | `string` | `"2.14.0"` | no |
| <a name="input_repo_path"></a> [repo\_path](#input\_repo\_path) | Local path to the repository containing templates | `string` | `"/root/.np/nullplatform/scopes"` | no |
| <a name="input_service_path"></a> [service\_path](#input\_service\_path) | Service path within the repository | `string` | `"k8s"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags to apply to identifier agent | `string` | n/a | yes |
<!-- END_TF_DOCS -->
