output "api_key" {
  description = "The generated API key value"
  value       = nullplatform_api_key.this.api_key
  sensitive   = true
}

output "id" {
  description = "The ID of the API key resource"
  value       = nullplatform_api_key.this.id
}
