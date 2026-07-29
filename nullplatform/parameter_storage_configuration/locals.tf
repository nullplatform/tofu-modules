locals {
  # Mirrors nullplatform's "aws-secrets-manager" provider specification schema
  # defaults (verified via `np provider specification list --slug aws-secrets-manager`),
  # so the attributes sent here always match what the API considers the default —
  # avoiding perpetual drift on fields the caller doesn't override.
  defaults = {
    sensibility = {
      applies_to = ["secret"]
    }
    setup = {
      kms_key_id = ""
    }
  }
}
