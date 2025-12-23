# Module: Azure Private DNS Zone

This module creates a private DNS zone in Azure with optional virtual network links.

## Features

- Creates an Azure private DNS zone
- Supports linking to multiple virtual networks
- Optional auto-registration of VM DNS records
- Supports configurable tags for resource management

## Usage

### Basic Example

```hcl
module "private_dns" {
  source          = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/private_dns?ref=v1.5.0"
  domain_name     = "privatelink.database.windows.net"
  resource_group  = "my-resource-group"
  subscription_id = "00000000-0000-0000-0000-000000000000"
  tags = {
    environment = "production"
    team        = "platform"
  }
}
```

## Important Notes

- **Domain name**: Can be any valid DNS domain name for private resolution (e.g., `privatelink.database.windows.net`, `internal.company.local`)
- **Virtual network links**: Required for DNS resolution within VNets
- **Auto-registration**: When `registration_enabled = true`, VM records are automatically created in the DNS zone

## Inputs

| Name | Description | Type | Required | Default |
|------|-------------|------|----------|---------|
| `resource_group` | The name of the resource group where the private DNS zone will be created | `string` | Yes | - |
| `domain_name` | The domain name to use for the private DNS zone | `string` | Yes | - |
| `subscription_id` | The ID of the Azure subscription | `string` | Yes | - |
| `virtual_network_links` | List of virtual networks to link to the private DNS zone | `list(object)` | No | `[]` |
| `tags` | A mapping of tags to assign to the resources | `map(string)` | No | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| `private_dns_zone_name` | The name of the created private DNS zone |
| `private_dns_zone_id` | The ID of the private DNS zone |
| `virtual_network_link_ids` | The IDs of the virtual network links |
