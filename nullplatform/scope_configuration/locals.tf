locals {
  # Defaults read from var.spec_schema (shape enforced by its validations), for
  # the keys the module sends only: the API fills defaults inside what it
  # receives, so a default for an unsent key would be a key the stored config
  # never has. A section with no defaults stays out too (an empty object is
  # drift against a config without it).
  spec_properties = try(var.spec_schema.properties, {})

  spec_section_defaults = {
    for section, p in local.spec_properties : section => {
      for field, fp in try(p.properties, {}) : field => fp.default
      if try(fp.default, null) != null
    }
  }

  spec_defaults = merge(
    { for k, p in local.spec_properties : k => p.default if try(p.default, null) != null && contains(keys(local.overrides), k) },
    { for k, v in local.spec_section_defaults : k => v if length(v) > 0 && contains(keys(local.overrides), k) },
  )

  ##############################################################################
  # static-files
  ##############################################################################
  # Built-in copy of the "static-files" spec defaults, used without
  # var.spec_schema. azure_* fields are included although only
  # cloud_provider = "aws" is supported: the API fills every non-null spec
  # default on write whatever the cloud, so omitting one is a perpetual diff.
  # Fields with no spec default are sent only when set.
  static_files_builtin_defaults = {
    cloud_provider = "aws"
    provider = {
      azure_state_auth = "azuread"
    }
    distribution = {
      aws_distribution                         = "cloudfront"
      azure_distribution                       = "front-door"
      azure_front_door_cache_days              = 7
      azure_front_door_security_headers        = false
      azure_front_door_certificate_secret      = ""
      azure_front_door_cached_path_prefixes    = ["/static/"]
      azure_front_door_content_security_policy = ""
    }
    network = {
      aws_network   = "route53"
      azure_network = "azure_dns"
    }
    security = {
      aws_security   = "none"
      azure_security = "none"
    }
  }

  # jsonencode round-trip: the two branches are objects of different shapes,
  # which a conditional can't unify.
  static_files_defaults = jsondecode(var.spec_schema == null
    ? jsonencode(local.static_files_builtin_defaults)
    : jsonencode(local.spec_defaults)
  )

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

  # Per-cloud override, layered over the defaults in local.payload. Adding a cloud: new key here + its variables, new
  # allowed value in variables.tf.
  static_files_cloud_overrides = {
    "aws" = {
      cloud_provider = var.cloud_provider
      provider = {
        aws_region       = var.aws_region
        aws_state_bucket = var.aws_state_bucket
      }
      distribution = {
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
      }
      network = {
        aws_network               = var.aws_network
        aws_hosted_public_zone_id = var.aws_hosted_public_zone_id
      }
      # aws_web_acl_name has no default in the spec, and is only read when
      # aws_security = "waf": sending an empty string adds a key a config
      # without a WebACL never had.
      security = merge(
        { aws_security = var.aws_security },
        var.aws_web_acl_name != "" ? { aws_web_acl_name = var.aws_web_acl_name } : {},
      )
    }
  }

  ##############################################################################
  # aws-lambda
  ##############################################################################
  # Built-in defaults, used without var.spec_schema: the spec has none for these
  # sections; the empty objects give local.payload's per-section merge a base.
  aws_lambda_builtin_defaults = {
    state      = {}
    deployment = {}
  }

  aws_lambda_defaults = jsondecode(var.spec_schema == null
    ? jsonencode(local.aws_lambda_builtin_defaults)
    : jsonencode(local.spec_defaults)
  )

  # `agent` is omitted unless a layer ARN is given: the schema makes it
  # optional, and an empty object would show up as drift.
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

  # Overrides win, but an object section is merged one level deep so a spec
  # default survives next to the fields the module sets in that section.
  # Deeper objects and lists are replaced whole.
  payload = merge(local.defaults, local.overrides, {
    for k, v in local.overrides : k => merge(local.defaults[k], v)
    if can(keys(v)) && can(keys(local.defaults[k]))
  })
}
