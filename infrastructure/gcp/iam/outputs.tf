output "service_accounts" {
  description = "A map of service account names to their email addresses"
  value       = { for k, v in google_service_account.sa : k => v.email }
}
