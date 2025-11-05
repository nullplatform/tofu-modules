# Azure Container Registry (ACR) Module

This module creates an Azure Container Registry using the Azure Verified Module (AVM).

## Features

- Creates Azure Container Registry with configurable SKU (Basic, Standard, Premium)
- Supports zone redundancy (Premium SKU only)
- Admin user enabled by default for easy authentication
- Configurable tags for resource management
- Name validation to ensure compliance with Azure naming requirements

## Usage

### Basic Example

```hcl
module "acr" {
  source                 = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/acr?ref=v1.5.0"
  containerregistry_name = var.containerregistry_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  subscription_id        = var.subscription_id
}
```

### With Tags

```hcl
module "acr" {
  source                 = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/acr?ref=v1.5.0"
  containerregistry_name = var.containerregistry_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  subscription_id        = var.subscription_id

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = "myproject"
  }
}
```

### Premium SKU with Zone Redundancy

```hcl
module "acr" {
  source                  = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/acr?ref=v1.5.0"
  containerregistry_name  = var.containerregistry_name
  resource_group_name     = var.resource_group_name
  location                = var.location
  subscription_id         = var.subscription_id
  sku                     = "Premium"
  zone_redundancy_enabled = true
}
```

## Important Notes

- **ACR Name Requirements**: Must be globally unique, 5-50 characters, lowercase alphanumeric only
- **Zone Redundancy**: Only available with Premium SKU
- **Admin User**: Enabled by default to retrieve admin credentials via outputs



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
| <a name="input_containerregistry_name"></a> [containerregistry\_name](#input\_containerregistry\_name) | The name of your ACR (must be globally unique, lowercase alphanumeric only, 5-50 characters) | `string` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The location/region where the resource group should be created | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group | `string` | n/a | yes |
| <a name="input_sku"></a> [sku](#input\_sku) | The SKU name of the container registry. Possible values: Basic, Standard, Premium | `string` | `"Basic"` | no |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The ID of your Azure Suscription | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the ACR resource | `map(string)` | `{}` | no |
| <a name="input_zone_redundancy_enabled"></a> [zone\_redundancy\_enabled](#input\_zone\_redundancy\_enabled) | Enable zone redundancy for the container registry (requires Premium SKU) | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_acr_admin_password"></a> [acr\_admin\_password](#output\_acr\_admin\_password) | Password admin del ACR. |
| <a name="output_acr_admin_username"></a> [acr\_admin\_username](#output\_acr\_admin\_username) | Usuario admin del ACR. |
| <a name="output_acr_login_server"></a> [acr\_login\_server](#output\_acr\_login\_server) | FQDN del login server del ACR. |
<!-- END_TF_DOCS -->