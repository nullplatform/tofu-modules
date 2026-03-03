# Module: eks

## Description

Configures Nullplatform provider settings for Amazon EKS cluster integration with customizable networking, resource management, and security options

## Features

- Creates Nullplatform provider configuration for EKS clusters
- Configures public and private load balancer names for traffic routing
- Manages resource allocation ratios for CPU and memory
- Supports custom Kubernetes namespace configuration or Nullplatform system namespace
- Configures image pull secrets for private container registry access
- Enables service account assignment for pod-level IAM permissions
- Supports dynamic Kubernetes object modifications through configurable modifiers

## Basic Usage

```hcl
module "eks" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/eks?ref=v1.41.1"

  cluster_name = "your-cluster-name"
  nrn          = "your-nrn"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.eks.id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.63 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | ~> 0.0.63 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.eks_config](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_balancer_group_suffix"></a> [balancer\_group\_suffix](#input\_balancer\_group\_suffix) | Suffix added to the ALB name, enabling management across multiple clusters in the same account | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the Amazon EKS cluster | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions for the provider configuration | `map(any)` | `{}` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | List of secret names to use image pull secrets for secure access to private container images | `list(string)` | `[]` | no |
| <a name="input_max_cores_multiplier"></a> [max\_cores\_multiplier](#input\_max\_cores\_multiplier) | Sets the ratio between requested and limit CPU. Default value is 3, must be a number greater than or equal to 1 | `string` | `""` | no |
| <a name="input_max_milicores"></a> [max\_milicores](#input\_max\_milicores) | Sets the maximum amount of CPU mili cores a pod can use | `string` | `""` | no |
| <a name="input_memory_cpu_ratio"></a> [memory\_cpu\_ratio](#input\_memory\_cpu\_ratio) | Amount of MiB of ram per CPU. Default value is 2048, it means 1 core for every 2 GiB of RAM | `string` | `""` | no |
| <a name="input_memory_request_to_limit_ratio"></a> [memory\_request\_to\_limit\_ratio](#input\_memory\_request\_to\_limit\_ratio) | Sets the ratio between requested and limit memory. Default value is 1, must be a number greater than or equal to 1 | `string` | `""` | no |
| <a name="input_namespace_application_default"></a> [namespace\_application\_default](#input\_namespace\_application\_default) | Default Kubernetes namespace for applications | `string` | `"nullplatform"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | nullplatform NRN (e.g., organization=X:account=Y:namespace=Z) | `string` | n/a | yes |
| <a name="input_object_modifiers"></a> [object\_modifiers](#input\_object\_modifiers) | List of modifications to dynamically modify k8s objects | `list(object)` | `[]` | no |
| <a name="input_private_balancer_name"></a> [private\_balancer\_name](#input\_private\_balancer\_name) | The name of the private load balancer for internal traffic routing | `string` | `""` | no |
| <a name="input_public_balancer_name"></a> [public\_balancer\_name](#input\_public\_balancer\_name) | The name of the public-facing load balancer for external traffic routing | `string` | `""` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | The name of the Kubernetes service account used for deployments | `string` | `""` | no |
| <a name="input_traffic_manager_version"></a> [traffic\_manager\_version](#input\_traffic\_manager\_version) | Tag for the traffic manager sidecar container | `string` | `"latest"` | no |
| <a name="input_use_nullplatform_namespace"></a> [use\_nullplatform\_namespace](#input\_use\_nullplatform\_namespace) | When enabled, uses the nullplatform system namespace instead of a custom namespace | `bool` | `false` | no |
<!-- END_TF_DOCS -->
