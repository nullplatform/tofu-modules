mock_provider "azurerm" {}

variables {
  location               = "eastus2"
  resource_group_name    = "rg-test"
  subscription_id        = "00000000-0000-0000-0000-000000000000"
  containerregistry_name = "acrmyorgpoc"
}

# Validates ACR plans with valid name
run "valid_acr_name" {
  command = plan
}

# Validates ACR name regex: rejects uppercase
run "rejects_uppercase_name" {
  command = plan

  variables {
    containerregistry_name = "AcrMyOrg"
  }

  expect_failures = [var.containerregistry_name]
}

# Validates ACR name regex: rejects hyphens
run "rejects_hyphens_in_name" {
  command = plan

  variables {
    containerregistry_name = "acr-my-org"
  }

  expect_failures = [var.containerregistry_name]
}

# Validates ACR name regex: rejects names shorter than 5 chars
run "rejects_short_name" {
  command = plan

  variables {
    containerregistry_name = "acr"
  }

  expect_failures = [var.containerregistry_name]
}

# Validates ACR plans with Premium SKU
run "premium_sku" {
  command = plan

  variables {
    sku = "Premium"
  }
}

# Validates ACR with retention policy
run "retention_policy" {
  command = plan

  variables {
    sku                      = "Premium"
    retention_policy_in_days = 30
  }
}

# admin_enabled defaults to true so existing installs keep their admin credentials
# (apply against the mock provider: admin_username/admin_password are computed
# by the registry, so they are unknown at plan time)
run "admin_enabled_by_default" {
  command = apply

  assert {
    condition     = var.admin_enabled == true
    error_message = "admin_enabled must default to true to stay backward compatible"
  }

  assert {
    condition     = output.acr_admin_username != null && output.acr_admin_password != null
    error_message = "admin credentials must be exposed while admin_enabled is true"
  }
}

# With the admin user disabled the module must not expose admin credentials
run "admin_disabled_hides_credentials" {
  command = apply

  variables {
    admin_enabled = false
  }

  assert {
    condition     = output.acr_admin_username == null && output.acr_admin_password == null
    error_message = "admin credentials must be null when admin_enabled is false"
  }
}
