mock_provider "nullplatform" {}

# spec_schema is shaped like scope-configuration.json.tpl's schema. future_field
# stands for a default the spec adds after the module's built-in copy was
# written; schema_version and unsent_section for defaults of keys the module
# doesn't send.
#
# fixtures/: *-schema.json are snapshots of the real templates' `schema`
# (scopes-static-files b061db1, scopes-lambda 3d8dfb6). Refresh from a checkout
# of the scope repo (the placeholders aren't valid JSON until replaced):
#   sed 's/"{{[^}]*}}"/"x"/' <scope>/specs/scope-configuration.json.tpl | jq .schema
# static-files-payload.json is the payload this module sent before spec_schema
# existed, for the static-files inputs of builtin_static_files_payload_is_unchanged.
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
      unsent_section = {
        type       = "object"
        properties = { enabled = { type = "boolean", default = true } }
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
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).schema_version)
    error_message = "a top-level default for a key the module doesn't send must stay omitted"
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

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).unsent_section)
    error_message = "a section the module doesn't send must stay omitted: the API doesn't fill it"
  }

  # azure_front_door_cache_days is a built-in default this spec_schema lacks.
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
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).triggers)
    error_message = "triggers must stay omitted: the module doesn't send it, so the API doesn't fill it"
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

run "aws_lambda_agent_spec_defaults_with_layer_arn" {
  command = plan

  variables {
    type                         = "aws-lambda"
    lambda_tofu_state_bucket     = "lambda-state"
    lambda_placeholder_image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/placeholder:latest"
    lambda_null_agent_layer_arn  = "arn:aws:lambda:us-east-1:123456789012:layer:agent:1"
    spec_schema = {
      type = "object"
      properties = {
        state      = { type = "object", properties = { tofu_state_bucket = { type = "string" } } }
        deployment = { type = "object", properties = { placeholder_image_uri = { type = "string" } } }
        agent = {
          type = "object"
          properties = {
            null_agent_layer_arn = { type = "string" }
            memory               = { type = "integer", default = 128 }
          }
        }
      }
    }
  }

  assert {
    condition = jsondecode(nullplatform_provider_config.scope_configuration.attributes).agent == {
      null_agent_layer_arn = "arn:aws:lambda:us-east-1:123456789012:layer:agent:1"
      memory               = 128
    }
    error_message = "agent's spec defaults must merge with the layer ARN"
  }
}

run "aws_lambda_agent_spec_defaults_without_layer_arn" {
  command = plan

  variables {
    type                         = "aws-lambda"
    lambda_tofu_state_bucket     = "lambda-state"
    lambda_placeholder_image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/placeholder:latest"
    spec_schema = {
      type = "object"
      properties = {
        state      = { type = "object", properties = { tofu_state_bucket = { type = "string" } } }
        deployment = { type = "object", properties = { placeholder_image_uri = { type = "string" } } }
        agent      = { type = "object", properties = { memory = { type = "integer", default = 128 } } }
      }
    }
  }

  assert {
    condition     = !can(jsondecode(nullplatform_provider_config.scope_configuration.attributes).agent)
    error_message = "without a layer ARN agent isn't sent, so its spec defaults must stay out"
  }
}

# A section the module sends but the spec lacks still carries the caller's values.
run "static_files_section_missing_from_spec" {
  command = plan

  variables {
    type                      = "static-files"
    cloud_provider            = "aws"
    aws_region                = "us-east-1"
    aws_state_bucket          = "tf-state"
    aws_hosted_public_zone_id = "Z0000000000000"
    spec_schema = {
      type = "object"
      properties = {
        cloud_provider = { type = "string", default = "aws" }
        provider       = { type = "object", properties = { aws_region = { type = "string" } } }
      }
    }
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).network.aws_hosted_public_zone_id == "Z0000000000000"
    error_message = "the caller's network settings must reach the payload without spec defaults"
  }

  assert {
    condition     = jsondecode(nullplatform_provider_config.scope_configuration.attributes).cloud_provider == "aws"
    error_message = "cloud_provider must be sent"
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

run "real_aws_lambda_spec_sends_the_same_payload" {
  command = plan

  variables {
    type                         = "aws-lambda"
    lambda_tofu_state_bucket     = "lambda-state"
    lambda_placeholder_image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/placeholder:latest"
    spec_schema                  = jsondecode(file("tests/fixtures/lambda-schema.json"))
  }

  # Same as without spec_schema: triggers is never sent and agent has no layer ARN.
  assert {
    condition = jsondecode(nullplatform_provider_config.scope_configuration.attributes) == {
      state      = { tofu_state_bucket = "lambda-state" }
      deployment = { placeholder_image_uri = "123456789012.dkr.ecr.us-east-1.amazonaws.com/placeholder:latest" }
    }
    error_message = "the real spec must yield the payload the module sends without it"
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

# A section with both its own default and fields is rejected: merging the two is
# unsupported and no spec needs it.
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
