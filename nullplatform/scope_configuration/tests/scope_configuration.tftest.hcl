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

run "static_files_distribution_defaults" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.azure_distribution == "blob-cdn"
    error_message = "azure_distribution must match the spec's own value, blob-cdn"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.default_viewer_protocol_policy == "redirect-to-https"
    error_message = "default_viewer_protocol_policy should mirror the spec default"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.default_cache_mode == "legacy"
    error_message = "default_cache_mode should mirror the spec default"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.default_compress == true
    error_message = "default_compress should mirror the spec default"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.price_class == "PriceClass_100"
    error_message = "price_class should mirror the spec default"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.default_root_object == "index.html"
    error_message = "default_root_object should mirror the spec default"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.geo_restriction.restriction_type == "none"
    error_message = "geo_restriction should mirror the spec default"
  }

  assert {
    condition     = length(jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.behaviors) == 0
    error_message = "behaviors should default to an empty list, as the spec declares"
  }

  assert {
    condition     = length(jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.custom_error_responses) == 0
    error_message = "custom_error_responses should default to an empty list, as the spec declares"
  }
}

run "static_files_default_invocations" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    aws_default_invocations = [
      { event_type = "Lambda@Edge - viewer response", function_arn = "arn:aws:lambda:us-east-1:123456789012:function:edge-headers:1" }
    ]
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.default_invocations[0].event_type == "Lambda@Edge - viewer response"
    error_message = "default_invocations should be passed through verbatim"
  }
}

run "static_files_legacy_associations_become_invocations" {
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
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.default_invocations[0].event_type == "Lambda@Edge - viewer response"
    error_message = "a legacy association must be translated to the spec's invocation wording"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.default_invocations[0].function_arn == "arn:aws:lambda:us-east-1:123456789012:function:edge-headers:1"
    error_message = "the function ARN must survive the translation"
  }

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.lambda_associations)
    error_message = "lambda_associations must no longer be sent: the spec dropped it"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.aws_distribution == "cloudfront"
    error_message = "translating a legacy association must keep the distribution defaults"
  }
}

run "static_files_behaviors" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    aws_behaviors = [
      {
        path_pattern = "/api/*"
        cache_mode   = "policy"
        cache_policy = "CachingDisabled"
        invocations = [
          { event_type = "Lambda@Edge - origin request", function_arn = "arn:aws:lambda:us-east-1:123456789012:function:auth:3" }
        ]
      }
    ]
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.behaviors[0].path_pattern == "/api/*"
    error_message = "the behavior's path_pattern should be passed through"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.behaviors[0].cache_policy == "CachingDisabled"
    error_message = "the behavior's cache_policy should be passed through"
  }

  assert {
    condition     = length(jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.behaviors[0].invocations) == 1
    error_message = "the behavior's invocations should be passed through"
  }
}

run "static_files_custom_error_responses" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    aws_custom_error_responses = [
      { error_code = 404, response_code = 200, response_page_path = "/index.html" }
    ]
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.custom_error_responses[0].error_code == 404
    error_message = "the SPA fallback should be passed through"
  }
}

run "static_files_rejects_unknown_cache_mode" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    aws_default_cache_mode    = "whatever"
  }

  expect_failures = [var.aws_default_cache_mode]
}

run "static_files_rejects_unknown_invocation_event" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    aws_default_invocations = [
      { event_type = "viewer-response", function_arn = "arn:aws:lambda:us-east-1:123456789012:function:f:1" }
    ]
  }

  expect_failures = [var.aws_default_invocations]
}
