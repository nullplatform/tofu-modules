output "nullplatform_cert_manager_role_arn" {
  description = "ARN of the cert-manager role"
  value       = var.identity_mode == "irsa" ? one(module.nullplatform_cert_manager_role[*].arn) : one(aws_iam_role.pod_identity[*].arn)
}
