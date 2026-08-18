output "service_specification_id" {
  value       = nullplatform_service_specification.from_template.id
  description = "The ID of the created service specification"
}

output "service_specification_slug" {
  value       = nullplatform_service_specification.from_template.slug
  description = "The slug of the created service specification"
}

# ------------------------------------------------------------------------------
# Package Outputs (null unless var.package is set)
# ------------------------------------------------------------------------------

output "package_id" {
  description = "ID of the package registered from this service definition, or null when packaging is disabled."
  value       = var.package != null ? nullplatform_package.this[0].id : null
}

output "package_published_revision_id" {
  description = "Revision UUID published for the configured package version, or null."
  value       = var.package != null ? nullplatform_package.this[0].published_revision_id : null
}

output "package_default_version" {
  description = "The package's default version after apply, or null."
  value       = var.package != null ? nullplatform_package.this[0].default_version : null
}

output "package_artifacts" {
  description = "Artifacts registered by this module: name => { resource_id, resource_revision_id }."
  value = {
    for k, v in nullplatform_artifact.package : k => {
      resource_id          = v.artifact_id
      resource_revision_id = v.id
    }
  }
}