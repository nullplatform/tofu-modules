mock_provider "azurerm" {
  mock_data "azurerm_container_registry_scope_map" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ContainerRegistry/registries/acrmyorgpoc/scopeMaps/_repositories_push"
    }
  }

  # The token password resource parses the token ID, so the mock needs a
  # well-formed one.
  mock_resource "azurerm_container_registry_token" {
    defaults = {
      id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ContainerRegistry/registries/acrmyorgpoc/tokens/nullplatform-ci-push"
    }
  }
}

variables {
  containerregistry_name = "acrmyorgpoc"
  resource_group_name    = "rg-test"
}

# The token is bound to the built-in push scope map, never to an admin-level one
run "binds_builtin_push_scope_map" {
  command = plan

  assert {
    condition     = data.azurerm_container_registry_scope_map.push.name == "_repositories_push"
    error_message = "the token must use the built-in _repositories_push scope map"
  }

  assert {
    condition     = azurerm_container_registry_token.this.scope_map_id == data.azurerm_container_registry_scope_map.push.id
    error_message = "the token must be bound to the push scope map"
  }
}

# The token name is the username CI logs in with
run "username_is_token_name" {
  command = plan

  variables {
    token_name = "ci-push"
  }

  assert {
    condition     = output.username == "ci-push"
    error_message = "username must be the token name"
  }
}

# Password never expires unless an expiry is set
run "password_without_expiry" {
  command = plan

  assert {
    condition     = azurerm_container_registry_token_password.this.password1[0].expiry == null
    error_message = "password1 must not expire by default"
  }
}

run "password_with_expiry" {
  command = plan

  variables {
    password_expiry = "2027-01-01T00:00:00Z"
  }

  assert {
    condition     = azurerm_container_registry_token_password.this.password1[0].expiry == "2027-01-01T00:00:00Z"
    error_message = "password1 must carry the configured expiry"
  }
}

# Rejects an expiry that is not an RFC 3339 timestamp
run "rejects_invalid_expiry" {
  command = plan

  variables {
    password_expiry = "2027-01-01"
  }

  expect_failures = [var.password_expiry]
}
