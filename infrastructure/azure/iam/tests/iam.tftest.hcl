mock_provider "azurerm" {
  # Role assignments and the federated credential parse these IDs, so the
  # mocks need well-formed ones.
  mock_resource "azurerm_user_assigned_identity" {
    defaults = {
      id           = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/mi-test"
      principal_id = "11111111-1111-1111-1111-111111111111"
      client_id    = "22222222-2222-2222-2222-222222222222"
    }
  }
}

variables {
  resource_group_name  = "rg-test"
  location             = "eastus2"
  name                 = "mi-test"
  oidc_issuer_url      = "https://oidc.example.com/abc/"
  namespace            = "nullplatform-tools"
  service_account_name = "nullplatform-agent"
}

# The original single-role interface keeps producing exactly one assignment
run "single_role_assignment_still_works" {
  command = plan

  variables {
    role_definition_name = "DNS Zone Contributor"
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/dnsZones/example.com"
  }

  assert {
    condition     = length(azurerm_role_assignment.this) == 1 && azurerm_role_assignment.this[0].role_definition_name == "DNS Zone Contributor"
    error_message = "role_definition_name + scope must create exactly one assignment"
  }

  assert {
    condition     = length(azurerm_role_assignment.additional) == 0
    error_message = "no additional assignments without role_assignments"
  }
}

# One assignment per role_assignments entry, keyed by the caller's name
run "role_assignments_creates_one_per_entry" {
  command = plan

  variables {
    role_assignments = {
      dns_public = {
        role_definition_name = "DNS Zone Contributor"
        scope                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/dnsZones/example.com"
      }
      dns_private = {
        role_definition_name = "Private DNS Zone Contributor"
        scope                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/privateDnsZones/example.internal"
      }
    }
  }

  assert {
    condition     = length(azurerm_role_assignment.this) == 0
    error_message = "the single-role assignment must not be created when role_definition_name is null"
  }

  assert {
    condition     = length(azurerm_role_assignment.additional) == 2 && azurerm_role_assignment.additional["dns_private"].role_definition_name == "Private DNS Zone Contributor"
    error_message = "role_assignments must create one assignment per entry, keyed by name"
  }
}

# Both interfaces can be combined
run "single_role_and_role_assignments_combine" {
  command = plan

  variables {
    role_definition_name = "DNS Zone Contributor"
    scope                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/dnsZones/example.com"
    role_assignments = {
      dns_private = {
        role_definition_name = "Private DNS Zone Contributor"
        scope                = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/privateDnsZones/example.internal"
      }
    }
  }

  assert {
    condition     = length(azurerm_role_assignment.this) == 1 && length(azurerm_role_assignment.additional) == 1
    error_message = "single role and role_assignments must add up"
  }
}

# An identity with no roles is valid (roles can be granted elsewhere)
run "identity_without_role_assignments" {
  command = plan

  assert {
    condition     = length(azurerm_role_assignment.this) == 0 && length(azurerm_role_assignment.additional) == 0
    error_message = "no role variables must mean no assignments"
  }
}

# role_definition_name without scope (or the reverse) is rejected
run "rejects_role_without_scope" {
  command = plan

  variables {
    role_definition_name = "DNS Zone Contributor"
  }

  expect_failures = [azurerm_role_assignment.this]
}

# scope without role_definition_name is rejected too
run "rejects_scope_without_role" {
  command = plan

  variables {
    scope = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/dnsZones/example.com"
  }

  expect_failures = [azurerm_user_assigned_identity.this]
}

# The federated credential trusts exactly the configured ServiceAccount
run "federated_credential_trusts_the_service_account" {
  command = plan

  assert {
    condition     = azurerm_federated_identity_credential.this.subject == "system:serviceaccount:nullplatform-tools:nullplatform-agent"
    error_message = "subject must be system:serviceaccount:<namespace>:<service_account_name>"
  }

  assert {
    condition     = azurerm_federated_identity_credential.this.audience == tolist(["api://AzureADTokenExchange"])
    error_message = "audience must be api://AzureADTokenExchange"
  }

  assert {
    condition     = azurerm_federated_identity_credential.this.issuer == "https://oidc.example.com/abc/"
    error_message = "issuer must be the cluster OIDC issuer URL"
  }
}

# A scope created in the same apply (unknown at plan) must still plan: count may
# only depend on role_definition_name.
run "single_role_with_scope_unknown_at_plan" {
  command = plan

  module {
    source = "./tests/fixtures/unknown_scope"
  }

  assert {
    condition     = output.client_id == "22222222-2222-2222-2222-222222222222"
    error_message = "the module must plan when scope is only known after apply"
  }
}
