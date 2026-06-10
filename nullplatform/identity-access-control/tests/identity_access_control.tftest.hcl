mock_provider "nullplatform" {}

variables {
  nrn = "organization=myorg:account=myaccount"
  attributes = {
    iam_role_arns = {
      arns = [
        { selector = "billing", arn = "arn:aws:iam::123456789012:role/billing-reader" },
        { selector = "analytics", arn = "arn:aws:iam::123456789012:role/analytics-reader" }
      ]
    }
  }
}

run "default_type_is_aws_iam_configuration" {
  command = plan

  assert {
    condition     = nullplatform_provider_config.identity_access_control.type == "aws-iam-configuration"
    error_message = "Provider config type should default to 'aws-iam-configuration'"
  }

  assert {
    condition     = nullplatform_provider_config.identity_access_control.nrn == "organization=myorg:account=myaccount"
    error_message = "NRN should match input"
  }
}

run "custom_type_for_new_cloud" {
  command = plan

  variables {
    type = "azure-iam-configuration"
  }

  assert {
    condition     = nullplatform_provider_config.identity_access_control.type == "azure-iam-configuration"
    error_message = "Provider config type should honor the type variable"
  }
}

run "attributes_are_json_encoded" {
  command = plan

  assert {
    condition     = can(jsondecode(nullplatform_provider_config.identity_access_control.attributes))
    error_message = "attributes should be valid JSON"
  }

  assert {
    condition     = length(jsondecode(nullplatform_provider_config.identity_access_control.attributes).iam_role_arns.arns) == 2
    error_message = "attributes should encode the provided structure verbatim"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.identity_access_control.attributes, "arn:aws:iam::123456789012:role/billing-reader")
    error_message = "attributes should contain the configured role ARN"
  }
}
