output "current_version_id" {
  description = "Id (spec_...) of the current version: what an approval action links to. It changes with every new version."
  value       = nullplatform_checklist_specification.this.current_version_id
}

output "version" {
  description = "Number of the current version."
  value       = nullplatform_checklist_specification.this.version
}

output "id" {
  description = "Id of the specification, <nrn>/<name>. Not a version id: approval actions link to current_version_id."
  value       = nullplatform_checklist_specification.this.id
}

output "name" {
  description = "Name of the specification."
  value       = nullplatform_checklist_specification.this.name
}

output "nrn" {
  description = "NRN the specification lives at."
  value       = nullplatform_checklist_specification.this.nrn
}
