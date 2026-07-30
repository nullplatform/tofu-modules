locals {
  # Mirrors nullplatform's provider specification schema defaults per
  # supported type (verified via `np provider specification list --slug
  # <type>`), so the attributes sent here always match what the API
  # considers the default for the selected type — avoiding perpetual drift
  # on fields the caller doesn't override. Adding a new type means: a new
  # key here, a new allowed value in variables.tf's type validation, and a
  # new section in the README documenting its payload.
  type_defaults = {
    "aws-secrets-manager" = {
      sensibility = {
        applies_to = ["secret"]
      }
      setup = {
        kms_key_id = ""
      }
    }
  }

  defaults = local.type_defaults[var.type]
}
