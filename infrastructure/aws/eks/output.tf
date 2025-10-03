output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "Nombre del cluster EKS"
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "Endpoint del API Server"
}

output "eks_cluster_ca" {
  value       = module.eks.cluster_certificate_authority_data
  description = "CA del cluster en base64"
  sensitive   = true
}

output "eks_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "ARN del OIDC provider del cluster"
}