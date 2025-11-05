# Azure Kubernetes Service (AKS) Module

This module creates an Azure Kubernetes Service (AKS) cluster using the official Azure AKS Terraform module.

## Features

- Creates production-ready AKS cluster with system and user node pools
- Configurable Kubernetes version
- Auto-scaling enabled for user node pools (1-5 nodes)
- Workload Identity and OIDC issuer enabled by default
- RBAC and Azure AD integration
- Configurable VM sizes for system and user node pools
- Support for private clusters
- API server IP whitelist support
- Zone redundancy for high availability
- Configurable tags for resource management

## Usage

### Basic Example

```hcl
module "aks" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/aks?ref=v1.5.0"
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  subscription_id     = var.subscription_id
  vnet_subnet_id      = var.vnet_subnet_id
  system_pool_vm_size = "Standard_D2s_v5"
  user_pool_vm_size   = "Standard_D2s_v5"
}
```

### With Resource Dependencies

```hcl
module "aks" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/aks?ref=v1.5.0"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  cluster_name        = var.cluster_name
  subscription_id     = var.subscription_id
  vnet_subnet_id      = module.vnet.subnet_ids_by_name["subnet-aks"]
  system_pool_vm_size = "Standard_D2s_v5"
  user_pool_vm_size   = "Standard_D2s_v5"

  depends_on = [module.resource_group, module.vnet]
}
```

### With Custom Configuration

```hcl
module "aks" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/aks?ref=v1.5.0"
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  subscription_id     = var.subscription_id
  vnet_subnet_id      = var.vnet_subnet_id

  # Node pool configuration
  system_pool_vm_size = "Standard_D4s_v5"
  user_pool_vm_size   = "Standard_D4s_v5"

  # Kubernetes version
  kubernetes_version = "1.32.7"

  # Security
  authorized_ip_ranges = ["203.0.113.0/24"]
  private_cluster_enabled = false

  # Identity
  oidc_issuer_enabled = true

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = "myproject"
  }
}
```

## Node Pool Configuration

The module creates two node pools:

- **System Node Pool**: For system pods and Kubernetes components
  - Configured via `system_pool_vm_size`
  - Default: Standard_D2s_v4

- **User Node Pool** (named "nodepool"): For application workloads
  - Configured via `user_pool_vm_size`
  - Default: Standard_D2s_v4
  - Auto-scaling: 1-5 nodes
  - Initial count: 2 nodes
  - Availability zones: 1, 2, 3

## Important Notes

- **Dependencies**: The AKS module **requires** `depends_on = [module.resource_group, module.vnet]` to ensure proper resource creation order
- **Workload Identity**: Enabled by default for enhanced security
- **OIDC Issuer**: Enabled by default for federated identity support
- **RBAC**: Azure RBAC is enabled at the cluster level
- **Networking**: Cluster uses CNI networking with the provided subnet
- **Upgrades**: Surge upgrades configured at 10% for system pool


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =4.41.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | =4.41.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_aks"></a> [aks](#module\_aks) | Azure/aks/azurerm | 11.0.0 |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_ip_ranges"></a> [authorized\_ip\_ranges](#input\_authorized\_ip\_ranges) | Set of authorized IP ranges to access the Kubernetes API server | `set(string)` | `null` | no |
| <a name="input_cluster_log_analytics_workspace_name"></a> [cluster\_log\_analytics\_workspace\_name](#input\_cluster\_log\_analytics\_workspace\_name) | The name of the Log Analytics workspace for cluster monitoring | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The name of the AKS cluster | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name for tagging and naming purposes | `string` | `"nullplatform"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | The version of Kubernetes to use for the AKS cluster | `string` | `"1.32.7"` | no |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the AKS cluster should be created (e.g., eastus, westus2) | `string` | n/a | yes |
| <a name="input_oidc_issuer_enabled"></a> [oidc\_issuer\_enabled](#input\_oidc\_issuer\_enabled) | Enable OIDC issuer for workload identity | `bool` | `true` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | Prefix for resources created by the AKS module | `string` | `"aks"` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | Enable private cluster mode (API server only accessible via private network) | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where AKS will be created | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The ID of your Azure Subscription | `string` | n/a | yes |
| <a name="input_system_pool_vm_size"></a> [system\_pool\_vm\_size](#input\_system\_pool\_vm\_size) | The VM size for the system node pool (e.g., Standard\_D2s\_v4, Standard\_D4s\_v4) | `string` | `"Standard_D2s_v5"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the AKS cluster and related resources | `map(string)` | `{}` | no |
| <a name="input_user_pool_vm_size"></a> [user\_pool\_vm\_size](#input\_user\_pool\_vm\_size) | The VM size for the user node pool (e.g., Standard\_D2s\_v5, Standard\_D4s\_v5) | `string` | `"Standard_D2s_v5"` | no |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id) | The ID of the subnet where AKS nodes will be deployed | `string` | n/a | yes |
<!-- END_TF_DOCS -->