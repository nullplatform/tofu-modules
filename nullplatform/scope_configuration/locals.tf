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
}
