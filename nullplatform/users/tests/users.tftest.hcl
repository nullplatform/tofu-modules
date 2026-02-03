mock_provider "nullplatform" {
  override_resource {
    target = nullplatform_user.nullplatform_user
    values = {
      id = 5001
    }
  }
}

variables {
  np_api_key = "test-api-key"
  nullplatform_users = {
    "john" = {
      email      = "john@example.com"
      first_name = "John"
      last_name  = "Doe"
      role_slug  = ["admin"]
      nrn        = "organization=myorg:account=myaccount"
    }
  }
}

run "creates_user" {
  command = plan

  assert {
    condition     = nullplatform_user.nullplatform_user["john"].email == "john@example.com"
    error_message = "User email should match input"
  }

  assert {
    condition     = nullplatform_user.nullplatform_user["john"].first_name == "John"
    error_message = "User first_name should be 'John'"
  }

  assert {
    condition     = nullplatform_user.nullplatform_user["john"].last_name == "Doe"
    error_message = "User last_name should be 'Doe'"
  }
}

run "creates_grant_for_user" {
  command = plan

  assert {
    condition     = nullplatform_authz_grant.nullplatform_user_role["john-admin"].role_slug == "admin"
    error_message = "Grant role_slug should be 'admin'"
  }

  assert {
    condition     = nullplatform_authz_grant.nullplatform_user_role["john-admin"].nrn == "organization=myorg:account=myaccount"
    error_message = "Grant NRN should match input"
  }
}

run "multiple_roles_per_user" {
  command = plan

  variables {
    nullplatform_users = {
      "jane" = {
        email      = "jane@example.com"
        first_name = "Jane"
        last_name  = "Smith"
        role_slug  = ["admin", "developer", "ops"]
        nrn        = "organization=myorg:account=myaccount"
      }
    }
  }

  assert {
    condition     = nullplatform_authz_grant.nullplatform_user_role["jane-admin"].role_slug == "admin"
    error_message = "Should create admin grant"
  }

  assert {
    condition     = nullplatform_authz_grant.nullplatform_user_role["jane-developer"].role_slug == "developer"
    error_message = "Should create developer grant"
  }

  assert {
    condition     = nullplatform_authz_grant.nullplatform_user_role["jane-ops"].role_slug == "ops"
    error_message = "Should create ops grant"
  }
}

run "multiple_users" {
  command = plan

  variables {
    nullplatform_users = {
      "alice" = {
        email      = "alice@example.com"
        first_name = "Alice"
        last_name  = "Johnson"
        role_slug  = ["developer"]
        nrn        = "organization=myorg:account=myaccount"
      }
      "bob" = {
        email      = "bob@example.com"
        first_name = "Bob"
        last_name  = "Williams"
        role_slug  = ["ops"]
        nrn        = "organization=myorg:account=myaccount"
      }
    }
  }

  assert {
    condition     = nullplatform_user.nullplatform_user["alice"].email == "alice@example.com"
    error_message = "Alice's email should match"
  }

  assert {
    condition     = nullplatform_user.nullplatform_user["bob"].email == "bob@example.com"
    error_message = "Bob's email should match"
  }
}
