mock_provider "nullplatform" {}

# spec_schema is shaped like scope-configuration.json.tpl's schema. future_field stands for a
# default the spec adds after the module's built-in copy was written.
variables {
  nrn = "organization=1:account=2"

  spec_schema = {
    type = "object"
    if   = { properties = { cloud_provider = { const = "aws" } } }
    then = { properties = { provider = { required = ["aws_region"] } } }
    properties = {
      cloud_provider = { type = "string", default = "aws" }
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

  # Without a schema the built-in copy still applies: these keys are not in the fixture.
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

# fixtures/*-schema.json are the `schema` of each scope's real
# scope-configuration.json.tpl. Switching an install to spec_schema must not
# change any value the built-in copy already sends.
run "real_static_files_spec_covers_builtin_defaults" {
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
    condition = alltrue(flatten([
      for k, v in local.static_files_builtin_defaults : can(keys(v))
      ? [for f, fv in v : try(local.static_files_defaults[k][f] == fv, false)]
      : [try(local.static_files_defaults[k] == v, false)]
    ]))
    error_message = "every built-in static-files default must match the real spec's"
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
