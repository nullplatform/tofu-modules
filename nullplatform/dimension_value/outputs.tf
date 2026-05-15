output "ids" {
  description = "Map of NRN to created dimension value ID."
  value       = { for nrn, dv in nullplatform_dimension_value.this : nrn => dv.id }
}

output "slugs" {
  description = "Map of NRN to created dimension value slug."
  value       = { for nrn, dv in nullplatform_dimension_value.this : nrn => dv.slug }
}
