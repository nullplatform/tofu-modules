# Module: security

## Description

Creates Azure Network Security Groups with security rules for Istio gateway traffic on AKS clusters

## Features

- Creates Network Security Group for public Istio gateway with HTTPS internet access and VNet-restricted health checks
- Creates Network Security Group for private Istio gateway with VNet-only access for both HTTPS and health checks
- Automatically derives VNet CIDR and Azure location from AKS cluster configuration
- Configures port 443 security rules for gateway HTTPS traffic with appropriate source restrictions
- Configures port 15021 security rules for Istio health check endpoints restricted to VNet CIDR
- Supports optional override of Azure location and network CIDR for custom configurations
- Tags all resources with cluster name and managed-by metadata for resource tracking

## Basic Usage

```hcl
module "security" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/security?ref=v1.42.0"

  cluster_name        = "your-cluster-name"
  resource_group_name = "your-resource-group-name"
}
```

## Using Outputs

```hcl
# Reference outputs in other resources
resource "example_resource" "this" {
  example_attribute = module.security.public_gateway_nsg_id
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | ~> 4.0 |

## Resources

| Name | Type |
|------|------|
| [azurerm_network_security_group.private_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_group.public_gateway](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_group) | resource |
| [azurerm_network_security_rule.private_gateway_deny_all](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.private_gateway_health_check](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.private_gateway_https](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.public_gateway_deny_health_check_internet](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.public_gateway_health_check](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |
| [azurerm_network_security_rule.public_gateway_https](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/network_security_rule) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_azure_location"></a> [azure\_location](#input\_azure\_location) | Override: The Azure region. If empty, derived automatically from cluster. | `string` | `""` | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | The AKS cluster name, used for naming security resources and deriving VNet. | `string` | n/a | yes |
| <a name="input_gateway_internal_enabled"></a> [gateway\_internal\_enabled](#input\_gateway\_internal\_enabled) | Whether the internal (private) gateway is enabled. | `bool` | `false` | no |
| <a name="input_gateways_enabled"></a> [gateways\_enabled](#input\_gateways\_enabled) | Whether public gateways are enabled. | `bool` | `true` | no |
| <a name="input_network_cidr"></a> [network\_cidr](#input\_network\_cidr) | Override: The network CIDR block. If empty, derived automatically from VNet. | `string` | `""` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | The resource group name for NSG resources. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_private_gateway_nsg_id"></a> [private\_gateway\_nsg\_id](#output\_private\_gateway\_nsg\_id) | The ID of the private gateway NSG. |
| <a name="output_public_gateway_nsg_id"></a> [public\_gateway\_nsg\_id](#output\_public\_gateway\_nsg\_id) | The ID of the public gateway NSG. |
<!-- END_TF_DOCS -->
