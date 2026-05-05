mock_provider "nullplatform" {}

variables {
  np_api_key = "test-api-key"
  nullplatform_accounts = {
    "acme" = {
      name                = "Acme Corp"
      repository_prefix   = "acme"
      repository_provider = "github"
      slug                = "acme-corp"
    }
  }
}

run "creates_single_account" {
  command = plan

  assert {
    condition     = nullplatform_account.nullplatform_account["acme"].name == "Acme Corp"
    error_message = "Account name should be 'Acme Corp'"
  }

  assert {
    condition     = nullplatform_account.nullplatform_account["acme"].slug == "acme-corp"
    error_message = "Account slug should be 'acme-corp'"
  }

  assert {
    condition     = nullplatform_account.nullplatform_account["acme"].repository_provider == "github"
    error_message = "Repository provider should be 'github'"
  }
}

run "creates_multiple_accounts" {
  command = plan

  variables {
    nullplatform_accounts = {
      "dev" = {
        name                = "Development"
        repository_prefix   = "dev"
        repository_provider = "github"
        slug                = "development"
      }
      "prod" = {
        name                = "Production"
        repository_prefix   = "prod"
        repository_provider = "gitlab"
        slug                = "production"
      }
    }
  }

  assert {
    condition     = nullplatform_account.nullplatform_account["dev"].name == "Development"
    error_message = "Dev account name should be 'Development'"
  }

  assert {
    condition     = nullplatform_account.nullplatform_account["prod"].repository_provider == "gitlab"
    error_message = "Prod account should use gitlab"
  }
}

run "uses_default_values" {
  command = plan

  variables {
    nullplatform_accounts = {
      "minimal" = {
        name = "Minimal Account"
      }
    }
  }

  assert {
    condition     = nullplatform_account.nullplatform_account["minimal"].repository_prefix == null
    error_message = "repository_prefix should be null when not provided"
  }

  assert {
    condition     = nullplatform_account.nullplatform_account["minimal"].repository_provider == null
    error_message = "repository_provider should be null when not provided"
  }

  assert {
    condition     = nullplatform_account.nullplatform_account["minimal"].slug == "poc-account"
    error_message = "Default slug should be 'poc-account'"
  }
}
