output "nullplatform_external_dns_role_arn" {
  description = "ARN of the external-dns role"
  value       = var.identity_mode == "irsa" ? module.nullplatform_external_dns_role[0].arn : aws_iam_role.pod_identity[0].arn
}
