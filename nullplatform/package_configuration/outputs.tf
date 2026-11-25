output "id" {
  description = "Changes every time the configuration runs. Depend on it to wait for the place to be configured."
  value       = terraform_data.this.id
}

output "nrn" {
  description = "NRN of the place configured."
  value       = var.nrn
}

output "dimensions" {
  description = "Dimensions of the place configured."
  value       = var.dimensions
}

output "agent" {
  description = "Tags of the agent that serves the place."
  value       = var.agent
}

output "status" {
  description = "How configuring the place ended, as the installation records it: active or failed. Null with read_record off."
  value       = try(local.record.status, null)
}

output "version" {
  description = "Version of the package the place was configured with, as the installation records it. Null with read_record off."
  value       = try(local.record.version, null)
}

output "outputs" {
  description = "What the package's own tasks answered for this place, by the names the package chose, as the installation records them. Empty when the package has none; null with read_record off."
  value       = try(jsondecode(local.record.outputs), null)
}

output "resources" {
  description = "What configuring created or used at this place, as the installation records it: one entry per component with its name, resource_type, id, ref and origin (created or imported). Null with read_record off."
  value       = try(jsondecode(local.record.resources), null)
}
