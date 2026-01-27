output "authorization_api_key" {
  value     = module.api_key.api_key
  sensitive = true
}
