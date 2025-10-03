resource "nullplatform_dimension" "environment" {
  name  = "Environment"
  order = 1
  nrn   = var.nrn
}

resource "nullplatform_dimension_value" "environment_value" {
  for_each     = toset(var.environments)
  dimension_id = nullplatform_dimension.environment.id
  name         = each.value
  nrn          = var.nrn
}