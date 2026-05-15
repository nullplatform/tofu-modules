locals {
  effective_nrns = var.nrn != null ? [var.nrn] : var.nrns
}

# Standalone validation resource so preconditions always run, even when
# `effective_nrns` is empty (which would otherwise skip preconditions
# attached directly to the dimension_value resource).
resource "terraform_data" "validation" {
  lifecycle {
    precondition {
      condition     = !(var.nrn != null && length(var.nrns) > 0)
      error_message = "Provide either `nrn` (single NRN) or `nrns` (list), not both."
    }
    precondition {
      condition     = var.nrn != null || length(var.nrns) > 0
      error_message = "Either `nrn` or `nrns` must be set with at least one value."
    }
  }
}

resource "nullplatform_dimension_value" "this" {
  for_each = toset(local.effective_nrns)

  dimension_id = var.dimension_id
  name         = var.name
  nrn          = each.value
}
