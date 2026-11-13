output "service_specification_id" {
  description = "Id of the published service specification."
  value       = module.service_definition.service_specification_id
}

output "service_specification_slug" {
  description = "Slug of the published service specification."
  value       = module.service_definition.service_specification_slug
}

output "package_id" {
  description = "Id of the package."
  value       = module.service_definition.package_id
}

output "package_version" {
  description = "Version published by this apply: the release tag without the v."
  value       = local.version
}

output "package_promoted" {
  description = "Whether the published revision became the package default."
  value       = local.promote_default
}

output "package_published_revision_id" {
  description = "Revision published by this apply."
  value       = module.service_definition.package_published_revision_id
}

output "package_default_version" {
  description = "The package's default version after this apply."
  value       = module.service_definition.package_default_version
}
