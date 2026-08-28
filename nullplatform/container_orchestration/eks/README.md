# Module: eks

## Description

Configures a Nullplatform EKS provider by creating a nullplatform_provider_config resource that encodes cluster, load balancer, network, resource management, security, and traffic manager settings as structured JSON attributes

## Architecture

The module assembles multiple local maps (cluster, balancer, network, resource_management, security, traffic_manager) from input variables and merges them into a single attributes object that is JSON-encoded. A single nullplatform_provider_config resource of type 'eks-configuration' is created using the nrn, dimensions, and the encoded attributes payload. Optional fields are conditionally included in the merged locals only when their values are non-empty or non-null, preventing unnecessary keys from appearing in the provider configuration. The resulting resource registers the EKS cluster configuration within the Nullplatform control plane.

## Features

- Creates a nullplatform_provider_config resource that registers EKS cluster configuration with the Nullplatform control plane
- Configures ALB load balancer settings including public, private, additional balancers, and capacity thresholds with 50–99% rule usage validation
- Pins the traffic manager sidecar container to a fixed version tag, preventing unintended upgrades from moving references like latest or main
- Configures traffic manager sidecar port binding with a valid 1–65535 range, supporting environments that restrict pod-to-pod traffic on port 80
- Manages Kubernetes resource allocation ratios including memory-to-CPU ratio, request-to-limit ratio, and maximum milicores per pod
- Supports dynamic Kubernetes object modification via configurable object_modifiers with selector, action, type, and value fields
- Configures security context including image pull secrets and Kubernetes service account name for deployment workloads

## Basic Usage

```hcl
module "eks" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/eks?ref=v6.20.0"

  cluster_name            = "your-cluster-name"
  nrn                     = "your-nrn"
  traffic_manager_version = "your-traffic-manager-version"
}
```

### Usage with Pinned Release Version

```hcl
module "eks" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/eks?ref=v6.20.0"

  cluster_name            = "your-cluster-name"
  nrn                     = "your-nrn"
  traffic_manager_version = "latest"
}
```

### Usage with Pinned Release Version

```hcl
module "eks" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/eks?ref=v6.20.0"

  cluster_name            = "your-cluster-name"
  nrn                     = "your-nrn"
  traffic_manager_version = "main"
}
```

### Usage with Pinned Release Version

```hcl
module "eks" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/eks?ref=v6.20.0"

  cluster_name            = "your-cluster-name"
  nrn                     = "your-nrn"
  traffic_manager_version = "master"
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
| <a name="requirement_nullplatform"></a> [nullplatform](#requirement\_nullplatform) | ~> 0.0.86 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_nullplatform"></a> [nullplatform](#provider\_nullplatform) | 0.0.95 |

## Resources

| Name | Type |
|------|------|
| [nullplatform_provider_config.eks_config](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_private_balancer_names"></a> [additional\_private\_balancer\_names](#input\_additional\_private\_balancer\_names) | Additional private load balancers to support scope deployments beyond the 100-rule ALB limit | `list(string)` | `[]` | no |
| <a name="input_additional_public_balancer_names"></a> [additional\_public\_balancer\_names](#input\_additional\_public\_balancer\_names) | Additional public-facing load balancers to support scope deployments beyond the 100-rule ALB limit | `list(string)` | `[]` | no |
| <a name="input_alb_capacity_threshold"></a> [alb\_capacity\_threshold](#input\_alb\_capacity\_threshold) | Maximum ALB rule usage percentage (50-99). The remaining capacity reserves slots for concurrent deployments. Higher values maximize ALB utilization but increase the risk of hitting the rule limit | `number` | `null` | no |
| <a name="input_balancer_group_suffix"></a> [balancer\_group\_suffix](#input\_balancer\_group\_suffix) | Suffix added to the ALB name, enabling management across multiple clusters in the same account | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the Amazon EKS cluster | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions for the provider configuration | `map(any)` | `{}` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | List of secret names to use image pull secrets for secure access to private container images | `list(string)` | `[]` | no |
| <a name="input_max_cores_multiplier"></a> [max\_cores\_multiplier](#input\_max\_cores\_multiplier) | Sets the ratio between requested and limit CPU. Default value is 3, must be a number greater than or equal to 1 | `string` | `""` | no |
| <a name="input_max_milicores"></a> [max\_milicores](#input\_max\_milicores) | Sets the maximum amount of CPU mili cores a pod can use | `string` | `""` | no |
| <a name="input_memory_cpu_ratio"></a> [memory\_cpu\_ratio](#input\_memory\_cpu\_ratio) | Amount of MiB of ram per CPU. Default value is 2048, it means 1 core for every 2 GiB of RAM | `string` | `""` | no |
| <a name="input_memory_request_to_limit_ratio"></a> [memory\_request\_to\_limit\_ratio](#input\_memory\_request\_to\_limit\_ratio) | Sets the ratio between requested and limit memory. Default value is 1, must be a number greater than or equal to 1 | `string` | `""` | no |
| <a name="input_namespace_application_default"></a> [namespace\_application\_default](#input\_namespace\_application\_default) | Default Kubernetes namespace for applications | `string` | `"nullplatform"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z) | `string` | n/a | yes |
| <a name="input_object_modifiers"></a> [object\_modifiers](#input\_object\_modifiers) | List of modifications to dynamically modify k8s objects | <pre>list(object({<br/>    selector = string<br/>    action   = string<br/>    type     = string<br/>    value    = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_private_balancer_name"></a> [private\_balancer\_name](#input\_private\_balancer\_name) | The name of the private load balancer for internal traffic routing | `string` | `""` | no |
| <a name="input_public_balancer_name"></a> [public\_balancer\_name](#input\_public\_balancer\_name) | The name of the public-facing load balancer for external traffic routing | `string` | `""` | no |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | The name of the Kubernetes service account used for deployments | `string` | `""` | no |
| <a name="input_traffic_manager_port"></a> [traffic\_manager\_port](#input\_traffic\_manager\_port) | Port the traffic manager sidecar binds inside the pod. Defaults to 80 when unset. Set a different port (10080 recommended) when the cluster does not allow pod-to-pod traffic on port 80, which surfaces as a healthy pod that receives no traffic because kubelet probes are node-local and bypass the filtering. Open the port for pod-to-pod traffic before setting this value | `number` | `null` | no |
| <a name="input_traffic_manager_version"></a> [traffic\_manager\_version](#input\_traffic\_manager\_version) | No default: every install pins this deliberately — see VERSIONS.md. Pinned rather than tracking latest: a moving tag means a pod restart can pull a different build with no apply in between. Tag for the traffic manager sidecar container | `string` | n/a | yes |
| <a name="input_use_nullplatform_namespace"></a> [use\_nullplatform\_namespace](#input\_use\_nullplatform\_namespace) | When enabled, uses the nullplatform system namespace instead of a custom namespace | `bool` | `false` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "eks",
  "description": "Configures a Nullplatform EKS provider by creating a nullplatform_provider_config resource that encodes cluster, load balancer, network, resource management, security, and traffic manager settings as structured JSON attributes",
  "architecture": "The module assembles multiple local maps (cluster, balancer, network, resource_management, security, traffic_manager) from input variables and merges them into a single attributes object that is JSON-encoded. A single nullplatform_provider_config resource of type 'eks-configuration' is created using the nrn, dimensions, and the encoded attributes payload. Optional fields are conditionally included in the merged locals only when their values are non-empty or non-null, preventing unnecessary keys from appearing in the provider configuration. The resulting resource registers the EKS cluster configuration within the Nullplatform control plane.",
  "features": [
    "Creates a nullplatform_provider_config resource that registers EKS cluster configuration with the Nullplatform control plane",
    "Configures ALB load balancer settings including public, private, additional balancers, and capacity thresholds with 50–99% rule usage validation",
    "Pins the traffic manager sidecar container to a fixed version tag, preventing unintended upgrades from moving references like latest or main",
    "Configures traffic manager sidecar port binding with a valid 1–65535 range, supporting environments that restrict pod-to-pod traffic on port 80",
    "Manages Kubernetes resource allocation ratios including memory-to-CPU ratio, request-to-limit ratio, and maximum milicores per pod",
    "Supports dynamic Kubernetes object modification via configurable object_modifiers with selector, action, type, and value fields",
    "Configures security context including image pull secrets and Kubernetes service account name for deployment workloads"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z)",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "The name of the Amazon EKS cluster",
      "required": true
    },
    {
      "name": "traffic_manager_version",
      "description": "No default: every install pins this deliberately — see VERSIONS.md. Pinned rather than tracking latest: a moving tag means a pod restart can pull a different build with no apply in between. Tag for the traffic manager sidecar container",
      "required": true
    },
    {
      "name": "additional_public_balancer_names",
      "description": "Additional public-facing load balancers to support scope deployments beyond the 100-rule ALB limit",
      "required": false
    },
    {
      "name": "additional_private_balancer_names",
      "description": "Additional private load balancers to support scope deployments beyond the 100-rule ALB limit",
      "required": false
    },
    {
      "name": "alb_capacity_threshold",
      "description": "Maximum ALB rule usage percentage (50-99). The remaining capacity reserves slots for concurrent deployments. Higher values maximize ALB utilization but increase the risk of hitting the rule limit",
      "required": false
    },
    {
      "name": "traffic_manager_port",
      "description": "Port the traffic manager sidecar binds inside the pod. Defaults to 80 when unset. Set a different port (10080 recommended) when the cluster does not allow pod-to-pod traffic on port 80, which surfaces as a healthy pod that receives no traffic because kubelet probes are node-local and bypass the filtering. Open the port for pod-to-pod traffic before setting this value",
      "required": false
    },
    {
      "name": "dimensions",
      "description": "Dimensions for the provider configuration",
      "required": false
    },
    {
      "name": "namespace_application_default",
      "description": "Default Kubernetes namespace for applications",
      "required": false
    },
    {
      "name": "use_nullplatform_namespace",
      "description": "When enabled, uses the nullplatform system namespace instead of a custom namespace",
      "required": false
    },
    {
      "name": "public_balancer_name",
      "description": "The name of the public-facing load balancer for external traffic routing",
      "required": false
    },
    {
      "name": "private_balancer_name",
      "description": "The name of the private load balancer for internal traffic routing",
      "required": false
    },
    {
      "name": "balancer_group_suffix",
      "description": "Suffix added to the ALB name, enabling management across multiple clusters in the same account",
      "required": false
    },
    {
      "name": "memory_cpu_ratio",
      "description": "Amount of MiB of ram per CPU. Default value is 2048, it means 1 core for every 2 GiB of RAM",
      "required": false
    },
    {
      "name": "memory_request_to_limit_ratio",
      "description": "Sets the ratio between requested and limit memory. Default value is 1, must be a number greater than or equal to 1",
      "required": false
    },
    {
      "name": "max_cores_multiplier",
      "description": "Sets the ratio between requested and limit CPU. Default value is 3, must be a number greater than or equal to 1",
      "required": false
    },
    {
      "name": "max_milicores",
      "description": "Sets the maximum amount of CPU mili cores a pod can use",
      "required": false
    },
    {
      "name": "image_pull_secrets",
      "description": "List of secret names to use image pull secrets for secure access to private container images",
      "required": false
    },
    {
      "name": "service_account_name",
      "description": "The name of the Kubernetes service account used for deployments",
      "required": false
    },
    {
      "name": "object_modifiers",
      "description": "List of modifications to dynamically modify k8s objects",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "e610f9fe4ab54f6b090e558e1546c149"
}
END_AI_METADATA -->
