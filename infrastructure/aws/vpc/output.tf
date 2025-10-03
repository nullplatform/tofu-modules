output "vpc_id" {
  value       = module.vpc.vpc_id
  description = "ID de la VPC"
}

output "private_subnets" {
  value       = module.vpc.private_subnets
  description = "Subnets privadas"
}

output "public_subnets" {
  value       = module.vpc.public_subnets
  description = "Subnets públicas"
}