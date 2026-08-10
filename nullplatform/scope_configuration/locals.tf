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
      azure_distribution = "blob_cdn"
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

  # Per-cloud override, merged on top of static_files_defaults. Adding a
  # cloud: new key here + its variables, new allowed value in variables.tf.
  static_files_cloud_overrides = {
    "aws" = {
      cloud_provider = var.cloud_provider
      provider = {
        aws_region       = var.aws_region
        aws_state_bucket = var.aws_state_bucket
      }
      distribution = merge(local.static_files_defaults.distribution, { aws_distribution = var.aws_distribution })
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
