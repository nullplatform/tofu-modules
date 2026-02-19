output "vpc_id" {
  description = "ID of the VPC"
  value       = module.vpc.vpc_id
}

output "eks_cluster_name" {
  description = "Name of the EKS cluster"
  value       = module.eks.eks_cluster_name
}

output "eks_cluster_endpoint" {
  description = "EKS cluster API endpoint"
  value       = module.eks.eks_cluster_endpoint
}

output "eks_cluster_ca" {
  description = "EKS cluster CA certificate (base64)"
  value       = module.eks.eks_cluster_ca
  sensitive   = true
}

output "eks_oidc_provider_arn" {
  description = "ARN of the EKS OIDC provider"
  value       = module.eks.eks_oidc_provider_arn
}

output "public_zone_id" {
  description = "Route53 public hosted zone ID"
  value       = module.route53.public_zone_id
}

output "public_zone_name" {
  description = "Route53 public hosted zone name"
  value       = module.route53.public_zone_name
}

output "private_zone_id" {
  description = "Route53 private hosted zone ID"
  value       = module.route53.private_zone_id
}

output "private_zone_name" {
  description = "Route53 private hosted zone name"
  value       = module.route53.private_zone_name
}

output "nameservers" {
  description = "NS records for the public hosted zone"
  value       = module.route53.nameservers
}
