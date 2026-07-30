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

  # Per-type override shape merged on top of type_defaults, built from that
  # type's own variables. Adding a new type means: a new key here (with its
  # own variables, not these aws-secrets-manager ones), a new key in
  # type_defaults above, a new allowed value in variables.tf's type
  # validation, and a new section in the README documenting its payload.
  # Each entry references its own type's key in type_defaults literally
  # (not the dynamic local.defaults) — this map is evaluated in full
  # regardless of which type ends up selected, so an entry can't reference
  # a different type's shape without risking a lookup error whenever that
  # other type is the one actually in use. The nested merge (rather than a
  # flat replacement) preserves any defaults not covered by this type's own
  # variables.
  type_overrides = {
    "aws-secrets-manager" = {
      sensibility = merge(local.type_defaults["aws-secrets-manager"].sensibility, { applies_to = var.applies_to })
      setup       = merge(local.type_defaults["aws-secrets-manager"].setup, { kms_key_id = var.kms_key_id })
    }
  }

  defaults  = local.type_defaults[var.type]
  overrides = local.type_overrides[var.type]
}
