
# ========================================
# OUTPUTS
# ========================================

output "internal_alb_dns_name" {
  description = "DNS name of internal load balancer"
  value       = aws_lb.internal.dns_name
}

output "internal_alb_zone_id" {
  description = "Zone ID of internal load balancer"
  value       = aws_lb.internal.zone_id
}

output "internal_alb_arn" {
  description = "ARN of internal load balancer"
  value       = aws_lb.internal.arn
}

output "public_alb_dns_name" {
  description = "DNS name of public load balancer"
  value       = aws_lb.public.dns_name
}

output "public_alb_zone_id" {
  description = "Zone ID of public load balancer"
  value       = aws_lb.public.zone_id
}

output "public_alb_arn" {
  description = "ARN of public load balancer"
  value       = aws_lb.public.arn
}