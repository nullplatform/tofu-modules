# Module: aks

## Description

Configures an AKS cluster in the Nullplatform by creating a provider configuration resource that encapsulates cluster settings, gateway configuration, resource management policies, and security parameters

## Architecture

The module builds a local.attributes map that aggregates cluster metadata, gateway specs, resource limits, and security settings, then passes this JSON-encoded structure to the nullplatform_provider_config resource of type aks-configuration. Inputs like cluster_name, resource_group, and gateway names flow into the attributes map, while optional blocks for resource_management and security are conditionally included based on non-empty variables. The resulting provider configuration is registered against the given NRN in the Nullplatform.

## Features

- Creates Nullplatform provider configuration for AKS clusters
- Configures public and optional private Application Gateway references
- Supports resource quotas for CPU/memory ratios and core limits
- Manages image pull secrets and service account mappings
- Enables traffic manager sidecar version specification
- Applies dynamic object modifiers for Kubernetes resources

## Basic Usage

```hcl
module "aks" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/container_orchestration/aks?ref=v6.16.1"

  cluster_name        = "your-cluster-name"
  nrn                 = "your-nrn"
  public_gateway_name = "your-public-gateway-name"
  resource_group      = "your-resource-group"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.aks.id
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
| [nullplatform_provider_config.aks_config](https://registry.terraform.io/providers/nullplatform/nullplatform/latest/docs/resources/provider_config) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authentication_mode"></a> [authentication\_mode](#input\_authentication\_mode) | The type of authentication used to connect the cluster (localAccounts, azureActiveDirectory, localandAAD) | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the AKS cluster | `string` | n/a | yes |
| <a name="input_dimensions"></a> [dimensions](#input\_dimensions) | Dimensions for the provider configuration | `map(any)` | `{}` | no |
| <a name="input_gateway_namespace"></a> [gateway\_namespace](#input\_gateway\_namespace) | Kubernetes namespace where the gateway is deployed | `string` | `"istio-ingress"` | no |
| <a name="input_image_pull_secrets"></a> [image\_pull\_secrets](#input\_image\_pull\_secrets) | List of secret names to use image pull secrets | `list(string)` | `[]` | no |
| <a name="input_max_cores_multiplier"></a> [max\_cores\_multiplier](#input\_max\_cores\_multiplier) | Sets the ratio between requested and limit CPU. Default value is 3, must be a number greater than or equal to 1 | `string` | `""` | no |
| <a name="input_max_milicores"></a> [max\_milicores](#input\_max\_milicores) | Sets the maximum amount of CPU mili cores a pod can use | `string` | `""` | no |
| <a name="input_memory_cpu_ratio"></a> [memory\_cpu\_ratio](#input\_memory\_cpu\_ratio) | Amount of MiB of ram per CPU. Default value is 2048, it means 1 core for every 2 GiB of RAM | `string` | `""` | no |
| <a name="input_memory_request_to_limit_ratio"></a> [memory\_request\_to\_limit\_ratio](#input\_memory\_request\_to\_limit\_ratio) | Sets the ratio between requested and limit memory. Default value is 1, must be a number greater than or equal to 1 | `string` | `""` | no |
| <a name="input_namespace_application_default"></a> [namespace\_application\_default](#input\_namespace\_application\_default) | Default Kubernetes namespace for applications | `string` | `"nullplatform"` | no |
| <a name="input_nrn"></a> [nrn](#input\_nrn) | Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z) | `string` | n/a | yes |
| <a name="input_object_modifiers"></a> [object\_modifiers](#input\_object\_modifiers) | List of modifications to dynamically modify k8s objects | <pre>list(object({<br/>    selector = string<br/>    action   = string<br/>    type     = string<br/>    value    = optional(string, "")<br/>  }))</pre> | `[]` | no |
| <a name="input_private_gateway_name"></a> [private\_gateway\_name](#input\_private\_gateway\_name) | Name of the private Application Gateway in AKS | `string` | `""` | no |
| <a name="input_public_gateway_name"></a> [public\_gateway\_name](#input\_public\_gateway\_name) | Name of the public Application Gateway in AKS | `string` | n/a | yes |
| <a name="input_resource_group"></a> [resource\_group](#input\_resource\_group) | Name of the resource group containing the AKS cluster | `string` | n/a | yes |
| <a name="input_service_account_name"></a> [service\_account\_name](#input\_service\_account\_name) | The name of the Kubernetes service account used for deployments | `string` | `""` | no |
| <a name="input_traffic_manager_version"></a> [traffic\_manager\_version](#input\_traffic\_manager\_version) | Tag for the traffic manager sidecar container | `string` | `""` | no |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "aks",
  "description": "Configures an AKS cluster in the Nullplatform by creating a provider configuration resource that encapsulates cluster settings, gateway configuration, resource management policies, and security parameters",
  "architecture": "The module builds a local.attributes map that aggregates cluster metadata, gateway specs, resource limits, and security settings, then passes this JSON-encoded structure to the nullplatform_provider_config resource of type aks-configuration. Inputs like cluster_name, resource_group, and gateway names flow into the attributes map, while optional blocks for resource_management and security are conditionally included based on non-empty variables. The resulting provider configuration is registered against the given NRN in the Nullplatform.",
  "features": [
    "Creates Nullplatform provider configuration for AKS clusters",
    "Configures public and optional private Application Gateway references",
    "Supports resource quotas for CPU/memory ratios and core limits",
    "Manages image pull secrets and service account mappings",
    "Enables traffic manager sidecar version specification",
    "Applies dynamic object modifiers for Kubernetes resources"
  ],
  "inputs": [
    {
      "name": "nrn",
      "description": "Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z)",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "The name of the AKS cluster",
      "required": true
    },
    {
      "name": "resource_group",
      "description": "Name of the resource group containing the AKS cluster",
      "required": true
    },
    {
      "name": "public_gateway_name",
      "description": "Name of the public Application Gateway in AKS",
      "required": true
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
      "name": "authentication_mode",
      "description": "The type of authentication used to connect the cluster (localAccounts, azureActiveDirectory, localandAAD)",
      "required": false
    },
    {
      "name": "gateway_namespace",
      "description": "Kubernetes namespace where the gateway is deployed",
      "required": false
    },
    {
      "name": "private_gateway_name",
      "description": "Name of the private Application Gateway in AKS",
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
      "description": "List of secret names to use image pull secrets",
      "required": false
    },
    {
      "name": "service_account_name",
      "description": "The name of the Kubernetes service account used for deployments",
      "required": false
    },
    {
      "name": "traffic_manager_version",
      "description": "Tag for the traffic manager sidecar container",
      "required": false
    },
    {
      "name": "object_modifiers",
      "description": "List of modifications to dynamically modify k8s objects",
      "required": false
    }
  ],
  "outputs": [],
  "hash": "2168cb7d36e77d4e500f63cf042628ee"
}
END_AI_METADATA -->
