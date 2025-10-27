# Modules: ACR

This module creates an Azure Container Registry.

Usage:


```
module "acr" {
  source = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/acr?ref=v1.0.0"
  name                = var.containerregistry_name
  resource_group_name = var.resource_group_name
  location            = var.location
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
| <a name="module_containerregistry"></a> [containerregistry](#module\_containerregistry) | azure/avm-res-containerregistry-registry/azurerm | v0.4.0 |

## Resources

| Name | Type |
|------|------|

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_containerregistry_name"></a> [containerregistry\_name](#input\_containerregistry\_name) | The name of your ACR | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resource group should be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | n/a | `string` | `"Standard"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The ID of your Azure Suscription | `string` | n/a | yes |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | n/a | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_admin_password"></a> [acr\_admin\_password](#output\_acr\_admin\_password) | Password admin del ACR. |
| <a name="output_acr_admin_username"></a> [acr\_admin\_username](#output\_acr\_admin\_username) | Usuario admin del ACR. |
| <a name="output_acr_login_server"></a> [acr\_login\_server](#output\_acr\_login\_server) | FQDN del login server del ACR. |
<!-- END_TF_DOCS -->