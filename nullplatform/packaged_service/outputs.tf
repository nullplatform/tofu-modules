output "package_id" {
  description = "ID of the published package."
  value       = nullplatform_package.this.id
}

output "package_slug" {
  description = "Slug of the published package."
  value       = nullplatform_package.this.slug
}

output "published_revision_id" {
  description = "Revision UUID published for package_version."
  value       = nullplatform_package.this.published_revision_id
}

output "default_version" {
  description = "The package's default version after apply."
  value       = nullplatform_package.this.default_version
}

output "default_revision_id" {
  description = "Revision that services bind to by default."
  value       = nullplatform_package.this.default_revision_id
}

output "artifacts" {
  description = "Artifacts registered by this module: name => { resource_id, resource_revision_id }."
  value = {
    for i, v in nullplatform_artifact.this : local.art_name[i] => {
      resource_id          = v.artifact_id
      resource_revision_id = v.id
    }
  }
}
