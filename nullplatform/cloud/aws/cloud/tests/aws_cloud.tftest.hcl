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
      name = "us-east-1"
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
