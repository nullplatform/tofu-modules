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
