# Modules: AKS

This module creates an Azure Kubernetes Services.

Usage:


```
module "aks" {
  source = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/aks?ref=v1.0.0"
  resource_group_name = module.resource_group.resource_group_name
  location            = module.resource_group.resource_group_location
  cluster_name        = var.cluster_name
  subscription_id     = var.subscription_id
  vnet_subnet_id      = module.vnet.subnet_ids_by_name["subnet1"]
  system_pool_vm_size = "Standard_D2s_v5"
  user_pool_vm_size   = "Standard_D2s_v5"
}
```


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
| <a name="input_authorized_ip_ranges"></a> [authorized\_ip\_ranges](#input\_authorized\_ip\_ranges) | n/a | `set(string)` | `null` | no |
| <a name="input_cluster_log_analytics_workspace_name"></a> [cluster\_log\_analytics\_workspace\_name](#input\_cluster\_log\_analytics\_workspace\_name) | n/a | `string` | `null` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | n/a | `any` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | `"nullplatform"` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | n/a | `string` | `"1.32.7"` | no |
| <a name="input_location"></a> [location](#input\_location) | n/a | `string` | n/a | yes |
| <a name="input_oidc_issuer_enabled"></a> [oidc\_issuer\_enabled](#input\_oidc\_issuer\_enabled) | n/a | `bool` | `true` | no |
| <a name="input_prefix"></a> [prefix](#input\_prefix) | n/a | `string` | `"test"` | no |
| <a name="input_private_cluster_enabled"></a> [private\_cluster\_enabled](#input\_private\_cluster\_enabled) | n/a | `bool` | `false` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | n/a | `string` | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | n/a | `string` | n/a | yes |
| <a name="input_system_pool_vm_size"></a> [system\_pool\_vm\_size](#input\_system\_pool\_vm\_size) | n/a | `string` | `"Standard_A4_v2"` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_user_pool_vm_size"></a> [user\_pool\_vm\_size](#input\_user\_pool\_vm\_size) | n/a | `string` | `"Standard_A4_v2"` | no |
| <a name="input_vnet_subnet_id"></a> [vnet\_subnet\_id](#input\_vnet\_subnet\_id) | n/a | `any` | n/a | yes |
<!-- END_TF_DOCS -->