locals {
  # Mirrors each supported type's own provider spec defaults, to avoid
  # drift on fields the caller doesn't override.
  type_defaults = {
    "aws-secrets-manager" = {
      sensibility = {
        applies_to = ["secret"]
      }
      setup = {
        kms_key_id = ""
      }
    }
    "aws-parameter-store" = {
      sensibility = {
        applies_to = ["non_secret"]
      }
      setup = {
        kms_key_id = ""
        tier       = "Standard"
      }
    }
  }

  # Per-type override, merged on top of type_defaults. Each entry indexes
  # type_defaults by its own literal key (not the dynamic local.defaults) —
  # this map is evaluated in full regardless of the selected type.
  type_overrides = {
    "aws-secrets-manager" = {
      sensibility = merge(local.type_defaults["aws-secrets-manager"].sensibility, {
        applies_to = coalesce(var.applies_to, local.type_defaults["aws-secrets-manager"].sensibility.applies_to)
      })
      setup = merge(local.type_defaults["aws-secrets-manager"].setup, { kms_key_id = var.kms_key_id })
    }
    "aws-parameter-store" = {
      sensibility = merge(local.type_defaults["aws-parameter-store"].sensibility, {
        applies_to = coalesce(var.applies_to, local.type_defaults["aws-parameter-store"].sensibility.applies_to)
      })
      setup = merge(local.type_defaults["aws-parameter-store"].setup, {
        kms_key_id = var.kms_key_id
        tier       = coalesce(var.tier, local.type_defaults["aws-parameter-store"].setup.tier)
      })
    }
  }

  defaults  = local.type_defaults[var.type]
  overrides = local.type_overrides[var.type]
}
