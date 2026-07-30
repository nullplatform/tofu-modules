locals {
  # Mirrors nullplatform's "static-files" provider specification schema defaults
  # (verified via `np provider specification list --slug static-files`, and
  # confirmed against a real apply with `ignore_changes` removed), so the
  # attributes sent here always match what the API considers the default —
  # avoiding perpetual drift on fields the caller doesn't override.
  #
  # azure_distribution/azure_network are included even though this module only
  # supports cloud_provider = "aws": the API silently persists every
  # schema-declared default regardless of which cloud_provider is selected, so
  # these must be mirrored here or every subsequent plan drifts on them.
  defaults = {
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

  # Per-cloud override shape merged on top of `defaults`, built from that
  # cloud's own variables. Unlike `defaults` above (shared across every
  # cloud because of the API drift issue), this map only ever needs the
  # active cloud's own fields, so it's keyed by cloud_provider like a normal
  # per-type override. Adding a new cloud means: a new key here with its own
  # variables, that cloud's own schema-default fields folded into `defaults`
  # above if the API requires them, a new allowed value in variables.tf's
  # cloud_provider validation, and a new section in the README.
  cloud_overrides = {
    "aws" = {
      cloud_provider = var.cloud_provider
      provider = {
        aws_region       = var.aws_region
        aws_state_bucket = var.aws_state_bucket
      }
      distribution = merge(local.defaults.distribution, { aws_distribution = var.aws_distribution })
      network = merge(local.defaults.network, {
        aws_network               = var.aws_network
        aws_hosted_public_zone_id = var.aws_hosted_public_zone_id
      })
      security = merge(local.defaults.security, {
        aws_security     = var.aws_security
        aws_web_acl_name = var.aws_web_acl_name
      })
    }
  }

  overrides = local.cloud_overrides[var.cloud_provider]
}
