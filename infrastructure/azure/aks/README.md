# Module: aks

## Description

Deploys an Azure Kubernetes Service (AKS) cluster with dual node pools, OIDC/Workload Identity, and optional ACR integration using the Azure/aks/azurerm community module

## Architecture

The module wraps the Azure/aks/azurerm community module (version 11.0.0) which internally provisions azurerm_kubernetes_cluster and azurerm_kubernetes_cluster_node_pool resources. A system node pool is created using agents_size with a dedicated subnet attachment, while a separate user node pool named 'nodepool' is configured with auto-scaling between 1 and 5 nodes across three availability zones. RBAC is enforced with Azure AD tenant binding, OIDC issuer and Workload Identity are enabled, and an optional AcrPull role assignment is made to the specified Azure Container Registry based on the attach_acr and acr_id inputs. Outputs expose the cluster endpoint, CA certificate, client credentials, OIDC issuer URL, and node resource group for downstream consumption.

## Features

- Creates an AKS cluster with a system node pool and a separate auto-scaling user node pool across three availability zones
- Enables OIDC issuer and Workload Identity for pod-level Azure identity federation
- Configures Azure RBAC with tenant-scoped AAD integration and role-based access control
- Attaches an Azure Container Registry with AcrPull role when acr_id is provided
- Assigns Network Contributor role on the specified VNet subnet for AKS networking
- Supports optional private cluster mode and API server authorized IP range restrictions
- Exposes cluster credentials, CA certificates, and OIDC issuer URL as sensitive outputs

## Basic Usage

```hcl
module "aks" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/aks?ref=v6.8.0"

  cluster_name        = "your-cluster-name"
  location            = "your-location"
  resource_group_name = "your-resource-group-name"
  subscription_id     = "your-subscription-id"
  vnet_subnet_id      = "your-vnet-subnet-id"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.aks.cluster_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.41.0 |
| <a name="provider_terraform"></a> [terraform](#provider\_terraform) | n/a |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | Azure/aks/azurerm | 11.0.0 |

## Resources

| Name | Type |
|------|------|
| [terraform_data.validations](https://registry.terraform.io/providers/hashicorp/terraform/latest/docs/resources/data) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_acr_id"></a> [acr\_id](#input\_acr\_id) | The ID of the Azure Container Registry. If provided, AKS will be granted AcrPull role to pull images. | `string` | `null` | no |
| <a name="input_attach_acr"></a> [attach\_acr](#input\_attach\_acr) | Whether to grant AKS the AcrPull role on acr\_id. Null (default) preserves the legacy behaviour of attaching whenever acr\_id is non-null. Set to true for a greenfield single-apply where acr\_id is known only after apply (keeps the for\_each key set plan-stable); set to false to disable. | `bool` | `null` | no |
| <a name="input_authorized_ip_ranges"></a> [authorized\_ip\_ranges](#input\_authorized\_ip\_ranges) | The set of authorized IP ranges allowed to access the Kubernetes API server | `set(string)` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the AKS cluster | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | The environment name used for tagging and naming purposes | `string` | `"nullplatform"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of Kubernetes to use for the AKS cluster | `string` | `"1.32.7"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the AKS cluster will be deployed (e.g., eastus, westus2) | `string` | n/a | yes |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | The prefix for resources created by the AKS module | `string` | `"aks"` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Whether to enable private cluster mode (API server accessible only via the private network) | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the AKS cluster will be created | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The ID of the Azure subscription | `string` | n/a | yes |
| <a name="input_system_pool_vm_size"></a> [system\_pool\_vm\_size](#input\_system\_pool\_vm\_size) | The VM size for the system node pool (e.g., Standard\_D2s\_v4, Standard\_D4s\_v4) | `string` | `"Standard_D2s_v5"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the AKS cluster and related resources | `map(string)` | `{}` | no |
| <a name="input_user_pool_vm_size"></a> [user\_pool\_vm\_size](#input\_user\_pool\_vm\_size) | The VM size for the user node pool (e.g., Standard\_D2s\_v5, Standard\_D4s\_v5) | `string` | `"Standard_D2s_v5"` | no |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id) | The ID of the subnet where AKS nodes will be deployed | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_admin_client_certificate"></a> [admin\_client\_certificate](#output\_admin\_client\_certificate) | The admin client certificate for authentication |
| <a name="output_admin_client_key"></a> [admin\_client\_key](#output\_admin\_client\_key) | The admin client key for authentication |
| <a name="output_admin_cluster_ca_certificate"></a> [admin\_cluster\_ca\_certificate](#output\_admin\_cluster\_ca\_certificate) | The admin cluster CA certificate in base64 |
| <a name="output_client_certificate"></a> [client\_certificate](#output\_client\_certificate) | The client certificate for authentication |
| <a name="output_client_key"></a> [client\_key](#output\_client\_key) | The client key for authentication |
| <a name="output_cluster_ca_certificate"></a> [cluster\_ca\_certificate](#output\_cluster\_ca\_certificate) | The cluster CA certificate in base64 |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | The name of the AKS cluster |
| <a name="output_host"></a> [host](#output\_host) | The API server endpoint |
| <a name="output_node_resource_group"></a> [node\_resource\_group](#output\_node\_resource\_group) | The name of the auto-generated resource group for AKS node resources |
| <a name="output_oidc_issuer_url"></a> [oidc\_issuer\_url](#output\_oidc\_issuer\_url) | The URL of the cluster's OIDC issuer |
<!-- END_TF_DOCS -->

<!-- BEGIN_AI_METADATA
{
  "name": "aks",
  "description": "Deploys an Azure Kubernetes Service (AKS) cluster with dual node pools, OIDC/Workload Identity, and optional ACR integration using the Azure/aks/azurerm community module",
  "architecture": "The module wraps the Azure/aks/azurerm community module (version 11.0.0) which internally provisions azurerm_kubernetes_cluster and azurerm_kubernetes_cluster_node_pool resources. A system node pool is created using agents_size with a dedicated subnet attachment, while a separate user node pool named 'nodepool' is configured with auto-scaling between 1 and 5 nodes across three availability zones. RBAC is enforced with Azure AD tenant binding, OIDC issuer and Workload Identity are enabled, and an optional AcrPull role assignment is made to the specified Azure Container Registry based on the attach_acr and acr_id inputs. Outputs expose the cluster endpoint, CA certificate, client credentials, OIDC issuer URL, and node resource group for downstream consumption.",
  "features": [
    "Creates an AKS cluster with a system node pool and a separate auto-scaling user node pool across three availability zones",
    "Enables OIDC issuer and Workload Identity for pod-level Azure identity federation",
    "Configures Azure RBAC with tenant-scoped AAD integration and role-based access control",
    "Attaches an Azure Container Registry with AcrPull role when acr_id is provided",
    "Assigns Network Contributor role on the specified VNet subnet for AKS networking",
    "Supports optional private cluster mode and API server authorized IP range restrictions",
    "Exposes cluster credentials, CA certificates, and OIDC issuer URL as sensitive outputs"
  ],
  "inputs": [
    {
      "name": "subscription_id",
      "description": "The ID of the Azure subscription",
      "required": true
    },
    {
      "name": "resource_group_name",
      "description": "The name of the resource group where the AKS cluster will be created",
      "required": true
    },
    {
      "name": "location",
      "description": "The Azure region where the AKS cluster will be deployed (e.g., eastus, westus2)",
      "required": true
    },
    {
      "name": "cluster_name",
      "description": "The name of the AKS cluster",
      "required": true
    },
    {
      "name": "vnet_subnet_id",
      "description": "The ID of the subnet where AKS nodes will be deployed",
      "required": true
    },
    {
      "name": "kubernetes_version",
      "description": "The version of Kubernetes to use for the AKS cluster",
      "required": false
    },
    {
      "name": "prefix",
      "description": "The prefix for resources created by the AKS module",
      "required": false
    },
    {
      "name": "system_pool_vm_size",
      "description": "The VM size for the system node pool (e.g., Standard_D2s_v4, Standard_D4s_v4)",
      "required": false
    },
    {
      "name": "user_pool_vm_size",
      "description": "The VM size for the user node pool (e.g., Standard_D2s_v5, Standard_D4s_v5)",
      "required": false
    },
    {
      "name": "authorized_ip_ranges",
      "description": "The set of authorized IP ranges allowed to access the Kubernetes API server",
      "required": false
    },
    {
      "name": "private_cluster_enabled",
      "description": "Whether to enable private cluster mode (API server accessible only via the private network)",
      "required": false
    },
    {
      "name": "tags",
      "description": "A mapping of tags to assign to the AKS cluster and related resources",
      "required": false
    },
    {
      "name": "environment",
      "description": "The environment name used for tagging and naming purposes",
      "required": false
    },
    {
      "name": "acr_id",
      "description": "The ID of the Azure Container Registry. If provided, AKS will be granted AcrPull role to pull images.",
      "required": false
    },
    {
      "name": "attach_acr",
      "description": "Whether to grant AKS the AcrPull role on acr_id. Null (default) preserves the legacy behaviour of attaching whenever acr_id is non-null. Set to true for a greenfield single-apply where acr_id is known only after apply (keeps the for_each key set plan-stable); set to false to disable.",
      "required": false
    }
  ],
  "outputs": [
    "cluster_name",
    "host",
    "cluster_ca_certificate",
    "client_certificate",
    "client_key",
    "admin_client_certificate",
    "admin_client_key",
    "admin_cluster_ca_certificate",
    "oidc_issuer_url",
    "node_resource_group"
  ],
  "hash": "a9e0d0d0a9c7729ab5f7b167c2db1b8d"
}
END_AI_METADATA -->
