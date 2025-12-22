output "nullplatform_cert_manager_role_arn" {
  description = "ARN of the cert-manager role"
  value       = module.nullplatform_cert_manager_role.arn
}

output "nullplatform_cert_manager_service_account_name" {
  description = "Name of the SA created"
  value = kubernetes_service_account_v1.cert_manager_acme_dns01_route53.metadata[0].name
}