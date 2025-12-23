output "service_accounts" {
  value = { for k, v in google_service_account.sa : k => v.email }
}
