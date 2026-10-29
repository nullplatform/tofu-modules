output "installation_id" {
  description = "ID of the package installation."
  value       = nullplatform_package_installation.this.id
}

output "package_id" {
  description = "ID of the installed package."
  value       = data.nullplatform_package.this.id
}

output "revision_id" {
  description = "ID of the installed package revision: the one new services and scopes are born with."
  value       = nullplatform_package_installation.this.default_revision_id
}

output "installed_version" {
  description = "Semver of the installed package revision."
  value       = nullplatform_package_installation.this.default_version
}

output "missing_optional_requirements" {
  description = "Optional providers the package can use that were not configured at nrn or above it when it was installed."
  value       = nullplatform_package_installation.this.missing_optional_requirements
}

output "components" {
  description = "Bill of materials of the installed revision. How the installing organization finds the resources of a package it does not own."
  value       = data.nullplatform_package.this.components
}

output "service_specification_ids" {
  description = "IDs of the service specifications in the installed revision. They are readable at nrn once the installation exists: depend on installation_id before reading them."
  value = [
    for component in data.nullplatform_package.this.components : component.resource_id
    if component.resource_type == "service_specification"
  ]
}
