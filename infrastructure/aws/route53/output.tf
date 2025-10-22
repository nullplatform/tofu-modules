output "public_zone_id" {
  description = "The ID of the Public Route 53 Hosted Zone"
  value       = aws_route53_zone.public_zone.zone_id
}

output "public_zone_name" {
  description = "The domain name of the Public Route 53 Hosted Zone"
  value       = aws_route53_zone.public_zone.name
}

output "private_zone_id" {
  description = "The ID of the Private Route 53 Hosted Zone"
  value       = aws_route53_zone.private_zone.zone_id
}

output "private_zone_name" {
  description = "The domain name of the Private Route 53 Hosted Zone"
  value       = aws_route53_zone.private_zone.name
}

output "acm_certificate_arn" {
  description = "The arn to Certificate of the Route 53 Hosted Zone"
  value       = module.aws_route53_acm.acm_certificate_arn
}