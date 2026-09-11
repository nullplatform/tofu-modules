mock_provider "nullplatform" {}

variables {
  nrn = "organization=1:account=2"
}

run "static_files_payload" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
  }

  assert {
    condition     = nullplatform_provider_config.scope_configuration.type == "static-files"
    error_message = "type should be static-files"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.aws_distribution == "cloudfront"
    error_message = "distribution should default to cloudfront"
  }

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.lambda_associations)
    error_message = "lambda_associations must be omitted when none are declared"
  }
}

run "static_files_lambda_associations" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    aws_lambda_associations = [
      { event_type = "viewer-response", function_arn = "arn:aws:lambda:us-east-1:123456789012:function:edge-headers:1" }
    ]
  }

  assert {
    condition     = length(jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.lambda_associations) == 1
    error_message = "one lambda association should be sent"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.lambda_associations[0].event_type == "viewer-response"
    error_message = "event_type should be passed through"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.aws_distribution == "cloudfront"
    error_message = "adding associations must keep the distribution defaults"
  }
}

run "static_files_rejects_unknown_event" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    aws_lambda_associations = [
      { event_type = "on-click", function_arn = "arn:aws:lambda:us-east-1:123456789012:function:f:1" }
    ]
  }

  expect_failures = [var.aws_lambda_associations]
}

run "aws_lambda_payload" {
  command = plan

  variables {
    type                         = "aws-lambda"
    lambda_tofu_state_bucket     = "lambda-state"
    lambda_placeholder_image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/placeholder:latest"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).state.tofu_state_bucket == "lambda-state"
    error_message = "state bucket should be passed through"
  }

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).agent)
    error_message = "agent block must be omitted without a layer ARN"
  }
}
