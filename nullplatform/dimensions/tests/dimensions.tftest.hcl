mock_provider "nullplatform" {
  override_resource {
    target = nullplatform_dimension.environment
    values = {
      id = 1001
    }
  }
}

variables {
  nrn        = "organization=myorg:account=myaccount"
  np_api_key = "test-api-key"
}

run "creates_environment_dimension" {
  command = plan

  assert {
    condition     = nullplatform_dimension.environment.name == "Environment"
    error_message = "Dimension name should be 'Environment'"
  }

  assert {
    condition     = nullplatform_dimension.environment.order == 1
    error_message = "Dimension order should be 1"
  }

  assert {
    condition     = nullplatform_dimension.environment.nrn == "organization=myorg:account=myaccount"
    error_message = "Dimension NRN should match input"
  }
}

run "creates_default_environment_values" {
  command = plan

  assert {
    condition     = nullplatform_dimension_value.environment_value["development"].name == "development"
    error_message = "Should create development environment value"
  }

  assert {
    condition     = nullplatform_dimension_value.environment_value["staging"].name == "staging"
    error_message = "Should create staging environment value"
  }

  assert {
    condition     = nullplatform_dimension_value.environment_value["production"].name == "production"
    error_message = "Should create production environment value"
  }
}

run "custom_environments" {
  command = plan

  variables {
    environments = ["dev", "qa", "uat", "prod"]
  }

  assert {
    condition     = nullplatform_dimension_value.environment_value["dev"].name == "dev"
    error_message = "Should create dev environment value"
  }

  assert {
    condition     = nullplatform_dimension_value.environment_value["uat"].name == "uat"
    error_message = "Should create uat environment value"
  }
}
