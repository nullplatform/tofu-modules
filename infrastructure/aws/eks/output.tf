output "eks_cluster_name" {
  value       = module.eks.cluster_name
  description = "EKS cluster name"
}

output "eks_cluster_endpoint" {
  value       = module.eks.cluster_endpoint
  description = "API Server endpoint"
}

output "eks_cluster_ca" {
  value       = module.eks.cluster_certificate_authority_data
  description = "Cluster CA in base64"
  sensitive   = true
}

output "eks_oidc_provider_arn" {
  value       = module.eks.oidc_provider_arn
  description = "ARN of the cluster's OIDC provider"
}