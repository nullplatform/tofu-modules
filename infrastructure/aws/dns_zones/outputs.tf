output "public_zone_id" {
  description = "The ID of the public Route 53 hosted zone (null if disabled)"
  value       = one(aws_route53_zone.public_zone[*].zone_id)
}

output "public_zone_name" {
  description = "The domain name of the public Route 53 hosted zone (null if disabled)"
  value       = one(aws_route53_zone.public_zone[*].name)
}

output "private_zone_id" {
  description = "The ID of the private Route 53 hosted zone (null if disabled)"
  value       = one(aws_route53_zone.private_zone[*].zone_id)
}

output "private_zone_name" {
  description = "The domain name of the private Route 53 hosted zone (null if disabled)"
  value       = one(aws_route53_zone.private_zone[*].name)
}

output "nameservers" {
  description = "NS records for the public hosted zone (null if disabled)"
  value       = try(join("\n", aws_route53_zone.public_zone[0].name_servers), null)
}
