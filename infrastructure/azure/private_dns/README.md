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
  source          = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/private_dns?ref=v1.x.x"
  domain_name     = "privatelink.database.windows.net"
  resource_group  = module.resource_group.resource_group_name
  subscription_id = var.subscription_id
}
```

### With Virtual Network Links

```hcl
module "private_dns" {
  source          = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/azure/private_dns?ref=v1.x.x"
  domain_name     = "private.example.com"
  resource_group  = module.resource_group.resource_group_name
  subscription_id = var.subscription_id

  virtual_network_links = [
    {
      vnet_id              = module.vnet.vnet_id
      registration_enabled = true
    }
  ]
}
```

## Important notes

- **Domain name**: Can be any valid DNS domain name for private resolution
- **Virtual network links**: Required for DNS resolution within VNets
- **Auto-registration**: When `registration_enabled = true`, VM records are automatically created

<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
