# Module: Agent

This code installs and manages the nullplatform agent in a Kubernetes cluster using a Helm chart from the nullplatform Helm repository. It ensures a controlled, reliable deployment with rollback and waiting behavior configured for stability and consistency.

## Usage

### Basic example

```hcl
module "cloud_aws_agent" {
  source                              = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v1.0.0"
  cluster_name                        = var.cluster_name
  nrn                                 = var.nrn
  np_api_key                          = var.np_api_key
  tags_selectors                      = var.tags_selectors
  namespace                           = var.namespace
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
| <a name="provider_helm"></a> [helm](#provider\_helm) | ~> 3.0 |
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [helm_release.agent](https://registry.terraform.io/providers/hashicorp/helm/latest/docs/resources/release) | resource |
| [nullplatform_api_key.nullplatform_agent_api_key](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/api_key) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_agent_repos_extra"></a> [agent\_repos\_extra](#input\_agent\_repos\_extra) | List of additional Git repositories used for extended agent configuration | `list(string)` | `[]` | no |
| <a name="input_agent_repos_scope"></a> [agent\_repos\_scope](#input\_agent\_repos\_scope) | Git repository URL containing agent scope configurations (format: repo#branch) | `string` | `"https://github.com/nullplatform/scopes.git#main"` | no |
| <a name="input_aws_iam_role_arn"></a> [aws\_iam\_role\_arn](#input\_aws\_iam\_role\_arn) | ARN of the AWS IAM role assigned to the agent | `string` | `""` | no |
| <a name="input_azure_client_id"></a> [azure\_client\_id](#input\_azure\_client\_id) | Azure client ID for authentication | `string` | `null` | no |
| <a name="input_azure_client_secret"></a> [azure\_client\_secret](#input\_azure\_client\_secret) | Azure client secret for authentication | `string` | `null` | no |
| <a name="input_azure_resource_group"></a> [azure\_resource\_group](#input\_azure\_resource\_group) | Azure resource group name | `string` | `null` | no |
| <a name="input_azure_subscription_id"></a> [azure\_subscription\_id](#input\_azure\_subscription\_id) | Azure subscription ID | `string` | `null` | no |
| <a name="input_azure_tenant_id"></a> [azure\_tenant\_id](#input\_azure\_tenant\_id) | Azure tenant ID | `string` | `null` | no |
| <a name="input_blue_green_ingress_path"></a> [blue\_green\_ingress\_path](#input\_blue\_green\_ingress\_path) | Specifies the ingress path used for blue-green deployments to route traffic to the new version. | `string` | `""` | no |
| <a name="input_cloud_provider"></a> [cloud\_provider](#input\_cloud\_provider) | Cloud provider to use (aws, gcp, or azure) | `string` | n/a | yes |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | Name of the EKS cluster where the nullplatform agent will be deployed | `string` | n/a | yes |
| <a name="input_dns_type"></a> [dns\_type](#input\_dns\_type) | Type of DNS Provider, ej: azure, aws, gcp, or external\_dns | `string` | `""` | no |
| <a name="input_domain"></a> [domain](#input\_domain) | Base domain name used across resources | `string` | `""` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | Image pull secrets configuration | `string` | `""` | no |
| <a name="input_image_tag"></a> [image\_tag](#input\_image\_tag) | Image tag for the agent container image | `string` | n/a | yes |
| <a name="input_init_scripts"></a> [init\_scripts](#input\_init\_scripts) | List of initialization scripts to execute during agent startup | `list(string)` | `[]` | no |
| <a name="input_initial_ingress_path"></a> [initial\_ingress\_path](#input\_initial\_ingress\_path) | Defines the initial ingress path used when deploying the application for the first time. | `string` | `""` | no |
| <a name="input_namespace"></a> [namespace](#input\_namespace) | Kubernetes namespace where the nullplatform agent will run | `string` | `"nullplatform-tools"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform Resource Name - unique identifier for nullplatform resources | `string` | n/a | yes |
| <a name="input_nullplatform_agent_helm_version"></a> [nullplatform\_agent\_helm\_version](#input\_nullplatform\_agent\_helm\_version) | Version of the nullplatform agent Helm chart to deploy | `string` | `"2.26.0"` | no |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Private gateway name for Azure networking | `string` | `null` | no |
| <a name="input_private_hosted_zone_rg"></a> [private\_hosted\_zone\_rg](#input\_private\_hosted\_zone\_rg) | Resource group for private hosted zone | `string` | `null` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Public gateway name for Azure networking | `string` | `null` | no |
| <a name="input_service_template"></a> [service\_template](#input\_service\_template) | Specifies the name or reference of the scope service template to be used for deployment. | `string` | `""` | no |
| <a name="input_tags_selectors"></a> [tags\_selectors](#input\_tags\_selectors) | Map of tags used to select and filter channels and agents | `map(string)` | n/a | yes |
| <a name="input_use_account_slug"></a> [use\_account\_slug](#input\_use\_account\_slug) | Flag to determine whether to use account slug in resource naming | `string` | `""` | no |
<!-- END_TF_DOCS -->
