mock_provider "nullplatform" {}

mock_provider "aws" {
  mock_data "aws_region" {
    defaults = {
      region = "us-east-1"
    }
  }
}

variables {
  nrn                  = "organization=myorg:account=myaccount"
  application_role_arn = "arn:aws:iam::123456789012:role/application-manager"
}

# The CI/CD block can be configured with an IAM role only. This is the setup
# `np asset push` uses on GitHub Actions: the role is assumed with the job's
# OIDC token and no static keys exist anywhere.
run "role_only" {
  command = plan

  variables {
    build_workflow_role_arn = "arn:aws:iam::123456789012:role/ci-image-pusher"
  }

  assert {
    condition     = nullplatform_provider_config.ecr.type == "ecr"
    error_message = "Provider config type should be 'ecr'"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.ecr.attributes).ci.role_arn == "arn:aws:iam::123456789012:role/ci-image-pusher"
    error_message = "ci.role_arn should carry the build workflow role"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.ecr.attributes).ci.region == "us-east-1"
    error_message = "ci.region should come from the current AWS region"
  }

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.ecr.attributes).ci.access_key)
    error_message = "ci.access_key must be omitted when no keys are given"
  }

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.ecr.attributes).ci.secret_key)
    error_message = "ci.secret_key must be omitted when no keys are given"
  }
}

# Existing callers keep passing a static key pair and get the same payload as
# before, without a role_arn key.
run "keys_only" {
  command = plan

  variables {
    build_workflow_access_key_id     = "AKIAIOSFODNN7EXAMPLE"
    build_workflow_access_key_secret = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.ecr.attributes).ci.access_key == "AKIAIOSFODNN7EXAMPLE"
    error_message = "ci.access_key should carry the build workflow access key id"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.ecr.attributes).ci.secret_key == "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
    error_message = "ci.secret_key should carry the build workflow secret"
  }

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.ecr.attributes).ci.role_arn)
    error_message = "ci.role_arn must be omitted when no role is given"
  }
}

# Both can coexist during a migration: the platform ignores the keys once a
# role is present, so a customer can add the role, verify, then drop the keys.
run "role_and_keys" {
  command = plan

  variables {
    build_workflow_role_arn          = "arn:aws:iam::123456789012:role/ci-image-pusher"
    build_workflow_access_key_id     = "AKIAIOSFODNN7EXAMPLE"
    build_workflow_access_key_secret = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.ecr.attributes).ci.role_arn == "arn:aws:iam::123456789012:role/ci-image-pusher"
    error_message = "ci.role_arn should be present alongside the keys"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.ecr.attributes).ci.access_key == "AKIAIOSFODNN7EXAMPLE"
    error_message = "ci.access_key should be present alongside the role"
  }
}

run "setup_block_is_unchanged" {
  command = plan

  variables {
    build_workflow_role_arn = "arn:aws:iam::123456789012:role/ci-image-pusher"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.ecr.attributes).setup.role_arn == "arn:aws:iam::123456789012:role/application-manager"
    error_message = "setup.role_arn should still carry the application role"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.ecr.attributes).setup.region == "us-east-1"
    error_message = "setup.region should come from the current AWS region"
  }
}

run "rejects_neither_role_nor_keys" {
  command = plan

  expect_failures = [terraform_data.validations]
}

run "rejects_access_key_id_without_secret" {
  command = plan

  variables {
    build_workflow_access_key_id = "AKIAIOSFODNN7EXAMPLE"
  }

  expect_failures = [terraform_data.validations]
}

run "rejects_secret_without_access_key_id" {
  command = plan

  variables {
    build_workflow_access_key_secret = "wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY"
  }

  expect_failures = [terraform_data.validations]
}

run "rejects_malformed_role_arn" {
  command = plan

  variables {
    build_workflow_role_arn = "not-an-arn"
  }

  expect_failures = [var.build_workflow_role_arn]
}
