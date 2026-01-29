mock_provider "nullplatform" {}

variables {
  name = "TEST-API-KEY"
  grants = [
    {
      nrn       = "organization=myorg:account=myaccount"
      role_slug = "admin"
    }
  ]
}

run "api_key_name" {
  command = plan

  assert {
    condition     = nullplatform_api_key.this.name == "TEST-API-KEY"
    error_message = "API key name should match input"
  }
}

run "with_multiple_grants" {
  command = plan

  variables {
    grants = [
      {
        nrn       = "organization=myorg:account=myaccount"
        role_slug = "admin"
      },
      {
        nrn       = "organization=myorg:account=myaccount"
        role_slug = "developer"
      },
      {
        nrn       = "organization=myorg:account=myaccount"
        role_slug = "ops"
      }
    ]
  }

  assert {
    condition     = nullplatform_api_key.this.name == "TEST-API-KEY"
    error_message = "API key name should match input"
  }
}

run "default_tags" {
  command = plan

  assert {
    condition     = nullplatform_api_key.this.name == "TEST-API-KEY"
    error_message = "API key name should match input"
  }
}

run "custom_tags" {
  command = plan

  variables {
    tags = [
      {
        key   = "environment"
        value = "production"
      },
      {
        key   = "team"
        value = "platform"
      }
    ]
  }

  assert {
    condition     = nullplatform_api_key.this.name == "TEST-API-KEY"
    error_message = "API key name should match input"
  }
}
