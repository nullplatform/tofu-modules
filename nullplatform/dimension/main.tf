resource "nullplatform_dimension" "this" {
  name  = var.name
  order = var.order
  nrn   = var.nrn
}

resource "nullplatform_dimension_value" "this" {
  for_each     = toset(var.values)
  dimension_id = nullplatform_dimension.this.id
  name         = each.value
  nrn          = var.nrn
}
