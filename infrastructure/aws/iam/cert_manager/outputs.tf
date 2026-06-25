output "nullplatform_cert_manager_role_arn" {
  description = "ARN of the cert-manager role"
  value       = var.identity_mode == "irsa" ? module.nullplatform_cert_manager_role[0].arn : aws_iam_role.pod_identity[0].arn
}
