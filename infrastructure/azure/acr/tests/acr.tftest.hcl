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
