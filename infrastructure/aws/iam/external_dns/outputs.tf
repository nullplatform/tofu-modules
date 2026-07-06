output "nullplatform_external_dns_role_arn" {
  description = "ARN of the external-dns role"
  value       = var.identity_mode == "irsa" ? one(module.nullplatform_external_dns_role[*].arn) : one(aws_iam_role.pod_identity[*].arn)
}
