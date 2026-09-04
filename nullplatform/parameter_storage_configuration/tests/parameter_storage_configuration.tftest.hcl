mock_provider "nullplatform" {}

variables {
  nrn = "organization=1:account=2"
}

run "secrets_manager_defaults" {
  command = plan

  variables {
    type = "aws-secrets-manager"
  }

  assert {
    condition     = nullplatform_provider_config.parameter_store_configuration.type == "aws-secrets-manager"
    error_message = "type should be aws-secrets-manager"
  }

  assert {
    condition     = jsonencode(jsondecode(nullplatform_provider_config.parameter_store_configuration.attributes).sensibility.applies_to) == jsonencode(["secret"])
    error_message = "aws-secrets-manager should default applies_to to [secret]"
  }

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.parameter_store_configuration.attributes).setup.tier)
    error_message = "tier must not be sent for aws-secrets-manager"
  }
}

run "parameter_store_defaults" {
  command = plan

  variables {
    type = "aws-parameter-store"
  }

  assert {
    condition     = nullplatform_provider_config.parameter_store_configuration.type == "aws-parameter-store"
    error_message = "type should be aws-parameter-store"
  }

  assert {
    condition     = jsonencode(jsondecode(nullplatform_provider_config.parameter_store_configuration.attributes).sensibility.applies_to) == jsonencode(["non_secret"])
    error_message = "aws-parameter-store should default applies_to to [non_secret]"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.parameter_store_configuration.attributes).setup.tier == "Standard"
    error_message = "tier should default to Standard"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.parameter_store_configuration.attributes).setup.kms_key_id == ""
    error_message = "kms_key_id should default to empty"
  }
}

run "parameter_store_overrides" {
  command = plan

  variables {
    type       = "aws-parameter-store"
    tier       = "Advanced"
    kms_key_id = "alias/my-key"
    applies_to = ["secret", "non_secret"]
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.parameter_store_configuration.attributes).setup.tier == "Advanced"
    error_message = "tier override should be applied"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.parameter_store_configuration.attributes).setup.kms_key_id == "alias/my-key"
    error_message = "kms_key_id override should be applied"
  }

  assert {
    condition     = length(jsondecode(nullplatform_provider_config.parameter_store_configuration.attributes).sensibility.applies_to) == 2
    error_message = "applies_to override should be applied"
  }
}

run "tier_rejected_for_secrets_manager" {
  command = plan

  variables {
    type = "aws-secrets-manager"
    tier = "Standard"
  }

  expect_failures = [var.tier]
}

run "unknown_type_rejected" {
  command = plan

  variables {
    type = "hashicorp-vault"
  }

  expect_failures = [var.type]
}
