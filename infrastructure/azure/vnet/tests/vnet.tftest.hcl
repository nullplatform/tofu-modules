mock_provider "azurerm" {}

# Validates subnet_ids_by_name output computes correctly from subnets_definition
run "subnet_ids_by_name_maps_correctly" {
  command = plan

  variables {
    vnet_name           = "vnet-myorg-poc"
    resource_group_name = "rg-myorg-poc"
    location            = "eastus2"
    subscription_id     = "00000000-0000-0000-0000-000000000000"
    address_space       = ["10.0.0.0/16"]
    subnets_definition = {
      subnet1 = {
        name             = "subnet-1"
        address_prefixes = ["10.0.0.0/24"]
      }
      subnet2 = {
        name             = "subnet-2"
        address_prefixes = ["10.0.1.0/24"]
      }
    }
  }

  assert {
    condition     = contains(keys(output.subnet_ids), "subnet-1")
    error_message = "subnet_ids_by_name should contain key 'subnet-1'"
  }

  assert {
    condition     = contains(keys(output.subnet_ids), "subnet-2")
    error_message = "subnet_ids_by_name should contain key 'subnet-2'"
  }

  assert {
    condition     = length(output.subnet_ids) == 2
    error_message = "subnet_ids_by_name should have exactly 2 entries"
  }
}

# Validates single subnet works
run "single_subnet_works" {
  command = plan

  variables {
    vnet_name           = "vnet-single"
    resource_group_name = "rg-test"
    location            = "eastus2"
    subscription_id     = "00000000-0000-0000-0000-000000000000"
    address_space       = ["10.0.0.0/16"]
    subnets_definition = {
      only = {
        name             = "only-subnet"
        address_prefixes = ["10.0.0.0/24"]
      }
    }
  }

  assert {
    condition     = length(output.subnet_ids) == 1
    error_message = "Should have exactly 1 subnet"
  }
}
