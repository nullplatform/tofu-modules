mock_provider "azurerm" {}

variables {
  resource_group_name = "rg-test"
  domain_name     = "myorg.nullimplementation.com"
  subscription_id = "00000000-0000-0000-0000-000000000000"
}

# Validates DNS zone is created with the correct domain name
run "creates_zone_with_domain" {
  command = plan

  assert {
    condition     = azurerm_dns_zone.public_dns_zone.name == "myorg.nullimplementation.com"
    error_message = "DNS zone name should match domain_name variable"
  }

  assert {
    condition     = azurerm_dns_zone.public_dns_zone.resource_group_name == "rg-test"
    error_message = "DNS zone should be in the specified resource group"
  }
}

# Validates outputs reference the same zone (catches the duplicate output bug)
run "outputs_reference_same_zone" {
  command = plan

  assert {
    condition     = output.dns_zone_name == output.private_dns_zone_name
    error_message = "dns_zone_name and private_dns_zone_name should match (both reference public zone)"
  }
}
