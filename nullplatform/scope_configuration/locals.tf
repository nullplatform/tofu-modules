locals {
  # Mirrors nullplatform's "static-files" provider specification schema defaults
  # (verified via `np provider specification list --slug static-files`), so the
  # attributes sent here always match what the API considers the default —
  # avoiding perpetual drift on fields the caller doesn't override.
  defaults = {
    cloud_provider = "aws"
    distribution = {
      aws_distribution = "cloudfront"
    }
    network = {
      aws_network = "route53"
    }
    security = {
      aws_security     = "none"
      aws_web_acl_name = ""
    }
  }
}
