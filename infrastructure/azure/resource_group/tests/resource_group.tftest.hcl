mock_provider "azurerm" {}

# Validates the resource group is created with correct attributes
run "creates_resource_group" {
  command = plan

  variables {
    resource_group_name = "rg-myorg-poc"
    location            = "eastus2"
    subscription_id     = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = azurerm_resource_group.nullplatform_resource_group.name == "rg-myorg-poc"
    error_message = "Expected resource group name 'rg-myorg-poc'"
  }

  assert {
    condition     = azurerm_resource_group.nullplatform_resource_group.location == "eastus2"
    error_message = "Expected location 'eastus2'"
  }
}

# Validates tags are propagated to the resource
run "propagates_tags" {
  command = plan

  variables {
    resource_group_name = "rg-test"
    location            = "westus2"
    subscription_id     = "00000000-0000-0000-0000-000000000000"
    tags = {
      environment = "testing"
      managed_by  = "tofu"
    }
  }

  assert {
    condition     = azurerm_resource_group.nullplatform_resource_group.tags["environment"] == "testing"
    error_message = "Expected tag 'environment' = 'testing'"
  }

  assert {
    condition     = azurerm_resource_group.nullplatform_resource_group.tags["managed_by"] == "tofu"
    error_message = "Expected tag 'managed_by' = 'tofu'"
  }
}

# Validates default empty tags don't break the resource
run "empty_tags_by_default" {
  command = plan

  variables {
    resource_group_name = "rg-notags"
    location            = "eastus2"
    subscription_id     = "00000000-0000-0000-0000-000000000000"
  }

  assert {
    condition     = length(azurerm_resource_group.nullplatform_resource_group.tags) == 0
    error_message = "Default tags should be an empty map"
  }
}
