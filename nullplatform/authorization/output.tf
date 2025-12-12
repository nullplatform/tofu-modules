output "authorization_api_key" {
  value     = nullplatform_api_key.nullplatform_agent_api_key.api_key
  sensitive = true
}