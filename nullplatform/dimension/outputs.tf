output "id" {
  description = "The ID of the created dimension. Use this to attach additional dimension values from a `dimension_value` module instance."
  value       = nullplatform_dimension.this.id
}

output "slug" {
  description = "The slug of the created dimension."
  value       = nullplatform_dimension.this.slug
}

output "nrn" {
  description = "The NRN where the dimension was created."
  value       = nullplatform_dimension.this.nrn
}
