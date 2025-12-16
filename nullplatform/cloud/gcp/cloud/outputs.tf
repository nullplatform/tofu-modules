output "provider_config_id" {
  description = "The ID of the nullplatform provider config"
  value       = nullplatform_provider_config.gcp.id
}

output "provider_config_nrn" {
  description = "The NRN of the nullplatform provider config"
  value       = nullplatform_provider_config.gcp.nrn
}
