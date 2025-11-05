# Azure Virtual Network (VNet) Module

This module creates an Azure Virtual Network with subnets using the Azure Verified Module (AVM).

## Features

- Creates Azure Virtual Network with configurable address space
- Creates multiple subnets within the VNet
- Configurable tags for resource management
- Output subnet IDs mapped by name for easy reference

## Usage

### Basic Example

```hcl
module "vnet" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/vnet?ref=v1.5.0"
  vnet_name           = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  subnets_definition  = var.subnets_definition
  subscription_id     = var.subscription_id
}
```

### With Resource Dependencies

```hcl
module "vnet" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/vnet?ref=v1.5.0"
  vnet_name           = var.vnet_name
  resource_group_name = module.resource_group.resource_group_name
  location            = var.location
  address_space       = ["10.3.0.0/16"]
  subscription_id     = var.subscription_id

  subnets_definition = {
    subnet1 = {
      name             = "subnet-aks"
      address_prefixes = ["10.3.0.0/18"]
    }
    subnet2 = {
      name             = "subnet-services"
      address_prefixes = ["10.3.64.0/18"]
    }
  }
}
```

### With Tags

```hcl
module "vnet" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/vnet?ref=v1.5.0"
  vnet_name           = var.vnet_name
  resource_group_name = var.resource_group_name
  location            = var.location
  address_space       = var.address_space
  subnets_definition  = var.subnets_definition
  subscription_id     = var.subscription_id

  tags = {
    Environment = "production"
    ManagedBy   = "terraform"
    Project     = "myproject"
  }
}
```

## Subnet Definition Example

```hcl
subnets_definition = {
  subnet1 = {
    name             = "subnet-aks"
    address_prefixes = ["10.3.0.0/18"]    # 10.3.0.0 - 10.3.63.255
  }
  subnet2 = {
    name             = "subnet-services"
    address_prefixes = ["10.3.64.0/18"]   # 10.3.64.0 - 10.3.127.255
  }
  subnet3 = {
    name             = "subnet-ingress"
    address_prefixes = ["10.3.128.0/18"]  # 10.3.128.0 - 10.3.191.255
  }
}
```

## Using Subnet Outputs

The module outputs `subnet_ids_by_name` which maps subnet names to their IDs:

```hcl
module "aks" {
  source         = "..."
  vnet_subnet_id = module.vnet.subnet_ids_by_name["subnet-aks"]
  # ...
}
```

## Important Notes

- **Address Space**: Ensure the address space is large enough for all planned subnets
- **Subnet Sizing**: Plan subnet sizes carefully based on expected resource counts
- **Naming**: Subnet names must be unique within the VNet


<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.6 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | =4.41.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_avm_res_network_virtualnetwork"></a> [avm\_res\_network\_virtualnetwork](#module\_avm\_res\_network\_virtualnetwork) | azure/avm-res-network-virtualnetwork/azurerm | v0.10.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_address_space"></a> [address\_space](#input\_address\_space) | The address space (CIDR blocks) for the Virtual Network (e.g., ["10.0.0.0/16"]) | `set(string)` | n/a | yes |
| <a name="input_location"></a> [location](#input\_location) | The Azure region where the VNet should be created (e.g., eastus, westus2) | `string` | n/a | yes |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The name of the resource group where the VNet will be created | `string` | n/a | yes |
| <a name="input_subnets_definition"></a> [subnets\_definition](#input\_subnets\_definition) | Map of subnets to create within the VNet. Each subnet requires a name and address_prefixes. | <pre>map(object({<br/>    name             = string<br/>    address_prefixes = list(string)<br/>  }))</pre> | n/a | yes |
| <a name="input_subscription_id"></a> [subscription\_id](#input\_subscription\_id) | The ID of your Azure Subscription | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | A mapping of tags to assign to the VNet and subnets | `map(string)` | `{}` | no |
| <a name="input_vnet_name"></a> [vnet\_name](#input\_vnet\_name) | The name of the Virtual Network | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_resource_id"></a> [resource\_id](#output\_resource\_id) | The resource ID of the virtual network. |
| <a name="output_subnet_ids_by_name"></a> [subnet\_ids\_by\_name](#output\_subnet\_ids\_by\_name) | Map of subnet names to their resource IDs |
<!-- END_TF_DOCS -->