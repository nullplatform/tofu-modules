# Module: security

## Description

Creates Azure Network Security Groups with security rules for Istio public and private gateway traffic control on AKS clusters

## Architecture

The module uses azurerm_kubernetes_cluster and azurerm_virtual_network data sources to automatically derive the Azure location and VNet CIDR from the AKS cluster when overrides are not provided. Two azurerm_network_security_group resources are conditionally created — one for the public gateway and one for the private/internal gateway — each controlled by boolean flags. Each NSG is populated with azurerm_network_security_rule resources that enforce port 443 and port 15021 access policies, with the public NSG allowing internet HTTPS while restricting health checks to VNet CIDR, and the private NSG restricting both ports to VNet CIDR only.

## Features

- Creates azurerm_network_security_group for public Istio gateway allowing internet HTTPS on port 443
- Creates azurerm_network_security_group for private Istio gateway restricting all traffic to VNet CIDR only
- Restricts Istio health check port 15021 to VNet CIDR on both public and private NSGs
- Automatically derives Azure location and VNet CIDR from AKS cluster and VNet data sources when overrides are not supplied
- Supports manual override of location and network CIDR to avoid bootstrap failures during initial AKS provisioning
- Outputs NSG IDs for both public and private gateways for downstream resource association

## Basic Usage

```hcl
module "security" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/azure/security?ref=v6.7.0"

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
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.73.0 |

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

<!-- BEGIN_AI_METADATA
{
  "name": "security",
  "description": "Creates Azure Network Security Groups with security rules for Istio public and private gateway traffic control on AKS clusters",
  "architecture": "The module uses azurerm_kubernetes_cluster and azurerm_virtual_network data sources to automatically derive the Azure location and VNet CIDR from the AKS cluster when overrides are not provided. Two azurerm_network_security_group resources are conditionally created — one for the public gateway and one for the private/internal gateway — each controlled by boolean flags. Each NSG is populated with azurerm_network_security_rule resources that enforce port 443 and port 15021 access policies, with the public NSG allowing internet HTTPS while restricting health checks to VNet CIDR, and the private NSG restricting both ports to VNet CIDR only.",
  "features": [
    "Creates azurerm_network_security_group for public Istio gateway allowing internet HTTPS on port 443",
    "Creates azurerm_network_security_group for private Istio gateway restricting all traffic to VNet CIDR only",
    "Restricts Istio health check port 15021 to VNet CIDR on both public and private NSGs",
    "Automatically derives Azure location and VNet CIDR from AKS cluster and VNet data sources when overrides are not supplied",
    "Supports manual override of location and network CIDR to avoid bootstrap failures during initial AKS provisioning",
    "Outputs NSG IDs for both public and private gateways for downstream resource association"
  ],
  "inputs": [
    {
      "name": "cluster_name",
      "description": "The AKS cluster name, used for naming security resources and deriving VNet.",
      "required": true
    },
    {
      "name": "resource_group_name",
      "description": "The resource group name for NSG resources.",
      "required": true
    },
    {
      "name": "gateways_enabled",
      "description": "Whether public gateways are enabled.",
      "required": false
    },
    {
      "name": "gateway_internal_enabled",
      "description": "Whether the internal (private) gateway is enabled.",
      "required": false
    },
    {
      "name": "azure_location",
      "description": "Override: The Azure region. If empty, derived automatically from cluster.",
      "required": false
    },
    {
      "name": "network_cidr",
      "description": "Override: The network CIDR block. If empty, derived automatically from VNet.",
      "required": false
    }
  ],
  "outputs": [
    "public_gateway_nsg_id",
    "private_gateway_nsg_id"
  ],
  "hash": "6c675ce57f21cce103dd9e4647c12797"
}
END_AI_METADATA -->
