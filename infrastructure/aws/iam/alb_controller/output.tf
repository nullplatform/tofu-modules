output "role_arn" {
  description = "ARN of the AWS Load Balancer Controller IAM role"
  value       = module.aws_load_balancer_controller_role.arn
}

output "service_account_name" {
  description = "Name of the Kubernetes service account for the AWS Load Balancer Controller"
  value       = kubernetes_service_account_v1.aws_load_balancer_controller_sa.metadata[0].name
}
