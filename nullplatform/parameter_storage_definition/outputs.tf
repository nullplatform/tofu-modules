output "specification_id" {
  description = "ID of the created parameter-storage provider specification."
  value       = nullplatform_provider_specification.parameter_storage_specification.id
}

output "slug" {
  description = "Slug of the provider specification, resolved from the rendered template. Pass this to parameter_storage_configuration.provider_specification_slug."
  value       = local.config.slug
}

output "name" {
  description = "Name of the provider specification, resolved from the rendered template."
  value       = local.config.name
}
