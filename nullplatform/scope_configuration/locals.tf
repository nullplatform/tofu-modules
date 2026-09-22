locals {
  ##############################################################################
  # static-files
  ##############################################################################
  # Mirrors the "static-files" provider spec's own defaults  to avoid drift.
  # azure_* fields are included even though only cloud_provider = "aws" is
  # supported: the API persists them regardless of the selected cloud.
  static_files_defaults = {
    cloud_provider = "aws"
    distribution = {
      aws_distribution   = "cloudfront"
      azure_distribution = "blob-cdn"
    }
    network = {
      aws_network   = "route53"
      azure_network = "azure_dns"
    }
    security = {
      aws_security     = "none"
      aws_web_acl_name = ""
    }
  }

  # The spec replaced distribution.lambda_associations with
  # distribution.default_invocations, which names the runtime alongside the
  # event ("Lambda@Edge - viewer response") so a behavior can also carry a
  # CloudFront Function. aws_lambda_associations is kept as an input and
  # translated here, so an install written against the old field keeps working
  # without emitting a field the spec no longer accepts.
  static_files_legacy_invocations = [
    for a in var.aws_lambda_associations : {
      event_type   = "Lambda@Edge - ${replace(a.event_type, "-", " ")}"
      function_arn = a.function_arn
    }
  ]

  # An explicit aws_default_invocations wins: it speaks the spec's own wording.
  static_files_default_invocations = (
    length(var.aws_default_invocations) > 0
    ? var.aws_default_invocations
    : local.static_files_legacy_invocations
  )

  # Per-cloud override, merged on top of static_files_defaults. Adding a
  # cloud: new key here + its variables, new allowed value in variables.tf.
  static_files_cloud_overrides = {
    "aws" = {
      cloud_provider = var.cloud_provider
      provider = {
        aws_region       = var.aws_region
        aws_state_bucket = var.aws_state_bucket
      }
      distribution = merge(
        local.static_files_defaults.distribution,
        {
          aws_distribution                = var.aws_distribution
          default_viewer_protocol_policy  = var.aws_default_viewer_protocol_policy
          default_compress                = var.aws_default_compress
          default_cache_mode              = var.aws_default_cache_mode
          default_cache_policy            = var.aws_default_cache_policy
          default_origin_request_policy   = var.aws_default_origin_request_policy
          default_response_headers_policy = var.aws_default_response_headers_policy
          default_invocations             = local.static_files_default_invocations
          behaviors                       = var.aws_behaviors
          custom_error_responses          = var.aws_custom_error_responses
          price_class                     = var.aws_price_class
          default_root_object             = var.aws_default_root_object
          # locations has no default in the spec: only sent when the caller
          # declares some, so a config without a restriction never drifts.
          geo_restriction = merge(
            { restriction_type = var.aws_geo_restriction.restriction_type },
            length(var.aws_geo_restriction.locations) > 0 ? { locations = var.aws_geo_restriction.locations } : {},
          )
        },
      )
      network = merge(local.static_files_defaults.network, {
        aws_network               = var.aws_network
        aws_hosted_public_zone_id = var.aws_hosted_public_zone_id
      })
      security = merge(local.static_files_defaults.security, {
        aws_security     = var.aws_security
        aws_web_acl_name = var.aws_web_acl_name
      })
    }
  }

  ##############################################################################
  # aws-lambda
  ##############################################################################
  # Mirrors scopes-lambda's specs/scope-configuration.json.tpl. `agent` is
  # omitted unless a layer ARN is given: the schema makes it optional, and an
  # empty object would show up as drift against a config that never had it.
  aws_lambda_defaults = {
    state      = {}
    deployment = {}
  }

  aws_lambda_overrides = merge(
    {
      state = {
        tofu_state_bucket = var.lambda_tofu_state_bucket
      }
      deployment = {
        placeholder_image_uri = var.lambda_placeholder_image_uri
      }
    },
    var.lambda_null_agent_layer_arn == null ? {} : {
      agent = {
        null_agent_layer_arn = var.lambda_null_agent_layer_arn
      }
    }
  )

  ##############################################################################
  # Type dispatch
  ##############################################################################
  # This map is evaluated in full regardless of the selected type, so the
  # static-files entry needs try(): cloud_provider is null for other types,
  # and indexing by null would error even though this branch goes unused.
  type_defaults = {
    "static-files" = local.static_files_defaults
    "aws-lambda"   = local.aws_lambda_defaults
  }

  type_overrides = {
    "static-files" = try(local.static_files_cloud_overrides[var.cloud_provider], {})
    "aws-lambda"   = local.aws_lambda_overrides
  }

  defaults  = local.type_defaults[var.type]
  overrides = local.type_overrides[var.type]
}
