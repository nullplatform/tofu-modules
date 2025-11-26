output "public_zone_id" {
  description = "The ID of the public Route 53 hosted zone"
  value       = aws_route53_zone.public_zone.zone_id
}

output "public_zone_name" {
  description = "The domain name of the public Route 53 hosted zone"
  value       = aws_route53_zone.public_zone.name
}

output "private_zone_id" {
  description = "The ID of the private Route 53 hosted zone"
  value       = aws_route53_zone.private_zone.zone_id
}

output "private_zone_name" {
  description = "The domain name of the private Route 53 hosted zone"
  value       = aws_route53_zone.private_zone.name
}

output "acm_certificate_arn" {
  description = "The ARN of the ACM certificate associated with the Route 53 hosted zone"
  value       = module.aws_route53_acm.acm_certificate_arn
}