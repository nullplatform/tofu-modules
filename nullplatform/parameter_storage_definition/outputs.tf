output "specification_id" {
  description = "ID of the created parameter-storage provider specification."
  value       = nullplatform_provider_specification.parameter_storage_specification.id
}

output "slug" {
  description = "Server-assigned slug of the provider specification. Pass this to parameter_storage_configuration.provider_specification_slug. Read from the created resource (not the template) so it reflects the slug the API actually assigned and orders instance registration after the spec exists."
  value       = local.config.slug
}

output "name" {
  description = "Name of the provider specification, resolved from the rendered template."
  value       = local.config.name
}
