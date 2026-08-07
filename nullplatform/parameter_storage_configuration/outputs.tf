output "provider_config_id" {
  description = "ID of the created provider config (parameter-storage instance)."
  value       = nullplatform_provider_config.parameter_store_configuration.id
}
