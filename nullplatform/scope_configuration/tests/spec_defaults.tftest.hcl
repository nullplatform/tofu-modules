mock_provider "nullplatform" {}

# spec_schema is shaped like scope-configuration.json.tpl's schema. future_field
# and schema_version stand for defaults the spec adds after the module's
# built-in copy was written.
#
# fixtures/: *-schema.json are the `schema` of the real templates
# (scopes-static-files b061db1, scopes-lambda 3d8dfb6); refresh with
# `jq .schema <scope>/specs/scope-configuration.json.tpl`. static-files-payload.json
# is the payload this module sent before spec_schema existed, for the inputs below.
variables {
  nrn = "organization=1:account=2"

  spec_schema = {
    type = "object"
    if   = { properties = { cloud_provider = { const = "aws" } } }
    then = { properties = { provider = { required = ["aws_region"] } } }
    properties = {
      cloud_provider = { type = "string", default = "aws" }
      schema_version = { type = "string", default = "v1" }
      provider = {
        type = "object"
        properties = {
          aws_region       = { type = "string" }
          azure_state_auth = { type = "string", default = "azuread" }
        }
      }
      distribution = {
        type = "object"
        properties = {
          aws_distribution = { type = "string", default = "cloudfront" }
          price_class      = { type = "string", default = "PriceClass_100" }
          future_field     = { type = "string", default = "from-spec" }
          off_by_default   = { type = "boolean", default = false }
          zero_by_default  = { type = "integer", default = 0 }
          empty_by_default = { type = "string", default = "" }
          null_default     = { type = "string", default = null }
          behaviors = {
            type    = "array"
            default = []
            items   = { type = "object", properties = { path_pattern = { type = "string", default = "/*" } } }
          }
        }
      }
      network = {
        type       = "object"
        properties = { aws_network = { type = "string", default = "route53" } }
      }
      security = {
        type       = "object"
        properties = { aws_security = { type = "string", default = "none" } }
      }
    }
  }
}

run "static_files_defaults_come_from_spec_schema" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.future_field == "from-spec"
    error_message = "a default only the spec declares must reach the payload"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).provider.azure_state_auth == "azuread"
    error_message = "provider defaults must come from the spec"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).provider.aws_region == "us-east-1"
    error_message = "a spec default must not drop the caller's provider settings"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).schema_version == "v1"
    error_message = "a top-level default no override sets must reach the payload"
  }

  assert {
    condition = (
      jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.off_by_default == false &&
      jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.zero_by_default == 0 &&
      jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.empty_by_default == ""
    )
    error_message = "false, 0 and \"\" are defaults, not missing ones"
  }

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.null_default)
    error_message = "a null default is no default: the API doesn't fill it"
  }

  # azure_front_door_cache_days is a built-in default this fixture lacks.
  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.azure_front_door_cache_days)
    error_message = "with a schema, the built-in defaults must not be merged in"
  }
}

run "static_files_caller_values_win_over_spec_defaults" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    aws_price_class           = "PriceClass_All"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).distribution.price_class == "PriceClass_All"
    error_message = "aws_price_class must override the spec default"
  }
}

run "aws_lambda_defaults_come_from_spec_schema" {
  command = plan

  variables {
    type                         = "aws-lambda"
    lambda_tofu_state_bucket     = "lambda-state"
    lambda_placeholder_image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/placeholder:latest"
    spec_schema = {
      type = "object"
      properties = {
        state = {
          type = "object"
          properties = {
            tofu_state_bucket = { type = "string" }
            future_field      = { type = "string", default = "from-spec" }
          }
        }
        deployment = { type = "object", properties = { placeholder_image_uri = { type = "string" } } }
        agent      = { type = "object", properties = { null_agent_layer_arn = { type = "string" } } }
        triggers = {
          type       = "object"
          properties = { invoke_permissions = { type = "array", default = [] } }
        }
      }
    }
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).triggers.invoke_permissions == []
    error_message = "triggers.invoke_permissions must mirror the spec default"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).state.tofu_state_bucket == "lambda-state"
    error_message = "a spec default must not drop the caller's state settings"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).state.future_field == "from-spec"
    error_message = "a spec default in a section the module also sets must survive the merge"
  }

  # A section with no defaults is not emitted: an empty object is drift.
  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).agent)
    error_message = "agent must stay omitted: the spec gives it no defaults and no layer ARN is set"
  }
}

run "aws_lambda_layer_arn_with_spec_schema" {
  command = plan

  variables {
    type                         = "aws-lambda"
    lambda_tofu_state_bucket     = "lambda-state"
    lambda_placeholder_image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/placeholder:latest"
    lambda_null_agent_layer_arn  = "arn:aws:lambda:us-east-1:123456789012:layer:agent:1"
    spec_schema                  = jsondecode(file("tests/fixtures/lambda-schema.json"))
  }

  # agent has no spec defaults, so it comes from the override alone.
  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).agent.null_agent_layer_arn == "arn:aws:lambda:us-east-1:123456789012:layer:agent:1"
    error_message = "the layer ARN must reach the payload when the spec gives agent no defaults"
  }
}

# The built-in copy and the real spec must send the same static-files payload.
run "builtin_static_files_payload_is_unchanged" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    spec_schema               = null
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes) == jsondecode(file("tests/fixtures/static-files-payload.json"))
    error_message = "without spec_schema the payload must be the one the module sent before it"
  }
}

run "real_static_files_spec_sends_the_same_payload" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    spec_schema               = jsondecode(file("tests/fixtures/static-files-schema.json"))
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes) == jsondecode(file("tests/fixtures/static-files-payload.json"))
    error_message = "the real spec must yield the payload the built-in copy sends"
  }
}

run "real_aws_lambda_spec_keeps_agent_omitted" {
  command = plan

  variables {
    type                         = "aws-lambda"
    lambda_tofu_state_bucket     = "lambda-state"
    lambda_placeholder_image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/placeholder:latest"
    spec_schema                  = jsondecode(file("tests/fixtures/lambda-schema.json"))
  }

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).agent)
    error_message = "the real spec gives agent no defaults: it must stay omitted"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).triggers.invoke_permissions == []
    error_message = "triggers.invoke_permissions must mirror the real spec default"
  }
}

# A malformed schema must fail: silently reading no defaults brings the drift back.
run "rejects_the_whole_template" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    spec_schema               = { name = "Static Files", schema = jsondecode(file("tests/fixtures/static-files-schema.json")) }
  }

  expect_failures = [var.spec_schema]
}

run "rejects_a_json_string" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    spec_schema               = file("tests/fixtures/static-files-schema.json")
  }

  expect_failures = [var.spec_schema]
}

run "rejects_a_schema_without_properties" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    spec_schema               = { type = "object" }
  }

  expect_failures = [var.spec_schema]
}

run "rejects_an_empty_schema" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    spec_schema               = {}
  }

  expect_failures = [var.spec_schema]
}

run "rejects_a_property_that_is_not_an_object" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    spec_schema               = { properties = { security = "none" } }
  }

  expect_failures = [var.spec_schema]
}

run "rejects_section_properties_that_are_not_an_object" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    spec_schema               = { properties = { network = { type = "object", properties = ["aws_network"] } } }
  }

  expect_failures = [var.spec_schema]
}

# Its own default and its fields' would have to be merged; no spec does this.
run "rejects_a_section_with_its_own_default" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    spec_schema = {
      properties = {
        network = { type = "object", default = {}, properties = { aws_network = { type = "string", default = "route53" } } }
      }
    }
  }

  expect_failures = [var.spec_schema]
}
