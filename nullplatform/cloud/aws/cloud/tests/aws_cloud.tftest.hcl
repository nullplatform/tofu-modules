mock_provider "nullplatform" {}

mock_provider "aws" {
  override_data {
    target = data.aws_caller_identity.current
    values = {
      account_id = "123456789012"
      id         = "123456789012"
    }
  }

  override_data {
    target = data.aws_region.current
    values = {
      region = "us-east-1"
    }
  }
}

variables {
  nrn                    = "organization=myorg:account=myaccount"
  np_api_key             = "test-api-key"
  domain_name            = "example.com"
  hosted_private_zone_id = "Z1234567890PRIV"
  hosted_public_zone_id  = "Z1234567890PUB"
}

run "aws_provider_type" {
  command = plan

  assert {
    condition     = nullplatform_provider_config.aws.type == "aws-configuration"
    error_message = "Provider config type should be 'aws-configuration'"
  }

  assert {
    condition     = nullplatform_provider_config.aws.nrn == "organization=myorg:account=myaccount"
    error_message = "NRN should match input"
  }
}

run "attributes_contain_account_info" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "123456789012")
    error_message = "Attributes should contain the AWS account ID"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "us-east-1")
    error_message = "Attributes should contain the AWS region"
  }
}

run "attributes_contain_networking" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "example.com")
    error_message = "Attributes should contain the domain name"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "Z1234567890PRIV")
    error_message = "Attributes should contain the private hosted zone ID"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "Z1234567890PUB")
    error_message = "Attributes should contain the public hosted zone ID"
  }
}

run "private_only_omits_public_zone" {
  command = plan

  variables {
    hosted_public_zone_id = ""
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.aws.attributes, "hosted_public_zone_id")
    error_message = "hosted_public_zone_id must be omitted from the payload when empty (private-only); the API rejects an empty string"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "Z1234567890PRIV")
    error_message = "Private hosted zone ID must still be present in private-only mode"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "example.com")
    error_message = "domain_name must still be present in private-only mode"
  }
}

run "private_only_omits_public_zone_when_null" {
  command = plan

  variables {
    hosted_public_zone_id = null
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.aws.attributes, "hosted_public_zone_id")
    error_message = "hosted_public_zone_id must be omitted from the payload when null (private-only)"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "Z1234567890PRIV")
    error_message = "Private hosted zone ID must still be present when public zone is null"
  }
}

run "rejects_malformed_public_zone_id" {
  command = plan

  variables {
    hosted_public_zone_id = "not-a-zone-id"
  }

  expect_failures = [
    var.hosted_public_zone_id,
  ]
}

run "explicit_account_and_region_override_the_data_sources" {
  command = plan

  variables {
    account_id = "210987654321"
    region     = "eu-west-1"
  }

  assert {
    condition     = length(data.aws_caller_identity.current) == 0
    error_message = "aws_caller_identity must not be read when account_id is provided"
  }

  assert {
    condition     = length(data.aws_region.current) == 0
    error_message = "aws_region must not be read when region is provided"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "210987654321")
    error_message = "Attributes should contain the account ID given by variable"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "eu-west-1")
    error_message = "Attributes should contain the region given by variable"
  }
}

run "explicit_account_still_resolves_region_from_data" {
  command = plan

  variables {
    account_id = "210987654321"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "210987654321")
    error_message = "Attributes should contain the account ID given by variable"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "us-east-1")
    error_message = "Region should still come from the data source when only account_id is set"
  }
}

run "rejects_malformed_account_id" {
  command = plan

  variables {
    account_id = ""
  }

  expect_failures = [
    var.account_id,
  ]
}

run "rejects_malformed_region" {
  command = plan

  variables {
    region = "us_east_1"
  }

  expect_failures = [
    var.region,
  ]
}

run "explicit_region_still_resolves_account_from_data" {
  command = plan

  variables {
    region = "eu-west-1"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "eu-west-1")
    error_message = "Attributes should contain the region given by variable"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.aws.attributes, "123456789012")
    error_message = "Account ID should still come from the data source when only region is set"
  }
}
