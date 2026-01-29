mock_provider "azurerm" {}

variables {
  resource_group  = "rg-test"
  domain_name     = "myorg.nullimplementation.com"
  subscription_id = "00000000-0000-0000-0000-000000000000"
}

# Validates private DNS zone is created with correct domain
run "creates_private_zone" {
  command = plan

  variables {
    virtual_network_links = [
      {
        vnet_id              = "/subscriptions/00000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet1"
        registration_enabled = false
      }
    ]
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zone.name == "myorg.nullimplementation.com"
    error_message = "Private DNS zone name should match domain_name"
  }
}

# Validates single VNet link is created
run "single_vnet_link" {
  command = plan

  variables {
    virtual_network_links = [
      {
        vnet_id              = "/subscriptions/00000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet1"
        registration_enabled = false
      }
    ]
  }

  assert {
    condition     = length(azurerm_private_dns_zone_virtual_network_link.vnet_link) == 1
    error_message = "Should create exactly 1 VNet link"
  }
}

# Validates multiple VNet links are created with for_each
run "multiple_vnet_links" {
  command = plan

  variables {
    virtual_network_links = [
      {
        vnet_id              = "/subscriptions/00000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet1"
        registration_enabled = false
      },
      {
        vnet_id              = "/subscriptions/00000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet2"
        registration_enabled = true
      }
    ]
  }

  assert {
    condition     = length(azurerm_private_dns_zone_virtual_network_link.vnet_link) == 2
    error_message = "Should create 2 VNet links"
  }
}

# Validates VNet link naming convention (vnet-link-{index})
run "vnet_link_naming" {
  command = plan

  variables {
    virtual_network_links = [
      {
        vnet_id              = "/subscriptions/00000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet1"
        registration_enabled = false
      }
    ]
  }

  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.vnet_link["0"].name == "vnet-link-0"
    error_message = "VNet link name should follow 'vnet-link-{index}' pattern"
  }
}

# Validates tags propagate to both zone and links
run "tags_propagate_to_all_resources" {
  command = plan

  variables {
    tags = {
      environment = "test"
    }
    virtual_network_links = [
      {
        vnet_id              = "/subscriptions/00000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet1"
        registration_enabled = false
      }
    ]
  }

  assert {
    condition     = azurerm_private_dns_zone.private_dns_zone.tags["environment"] == "test"
    error_message = "Tags should propagate to the private DNS zone"
  }

  assert {
    condition     = azurerm_private_dns_zone_virtual_network_link.vnet_link["0"].tags["environment"] == "test"
    error_message = "Tags should propagate to VNet links"
  }
}
