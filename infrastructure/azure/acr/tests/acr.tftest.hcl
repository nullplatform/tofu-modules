mock_provider "azurerm" {}

variables {
  location               = "eastus2"
  resource_group_name    = "rg-test"
  subscription_id        = "00000000-0000-0000-0000-000000000000"
  containerregistry_name = "acrmyorgpoc"
}

# Validates ACR name regex: must be lowercase alphanumeric, 5-50 chars
run "valid_acr_name" {
  command = plan
}

# Validates ACR rejects names with uppercase
run "rejects_uppercase_name" {
  command = plan

  variables {
    containerregistry_name = "AcrMyOrg"
  }

  expect_failures = [var.containerregistry_name]
}

# Validates ACR rejects names with hyphens
run "rejects_hyphens_in_name" {
  command = plan

  variables {
    containerregistry_name = "acr-my-org"
  }

  expect_failures = [var.containerregistry_name]
}

# Validates ACR rejects names shorter than 5 chars
run "rejects_short_name" {
  command = plan

  variables {
    containerregistry_name = "acr"
  }

  expect_failures = [var.containerregistry_name]
}

# Validates admin_enabled is true (required for nullplatform)
run "admin_enabled" {
  command = plan

  assert {
    condition     = module.containerregistry.admin_enabled == true
    error_message = "ACR admin must be enabled"
  }
}

# Validates default SKU is Basic
run "default_sku_is_basic" {
  command = plan

  assert {
    condition     = module.containerregistry.sku == "Basic"
    error_message = "Default SKU should be Basic"
  }
}

# Validates retention_policy_in_days is null by default (not applicable for Basic SKU)
run "retention_null_by_default" {
  command = plan

  assert {
    condition     = module.containerregistry.retention_policy_in_days == null
    error_message = "Retention policy should be null by default"
  }
}
