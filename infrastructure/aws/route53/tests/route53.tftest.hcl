mock_provider "aws" {}

variables {
  domain_name = "myorg.example.com"
  vpc_id      = "vpc-12345678"
}

run "public_zone_uses_domain" {
  command = plan

  assert {
    condition     = aws_route53_zone.public_zone.name == "myorg.example.com"
    error_message = "Public zone should use the provided domain name"
  }
}

run "private_zone_uses_same_domain" {
  command = plan

  assert {
    condition     = aws_route53_zone.private_zone.name == "myorg.example.com"
    error_message = "Private zone should use the same domain name as public"
  }
}

run "both_zones_force_destroy" {
  command = plan

  assert {
    condition     = aws_route53_zone.public_zone.force_destroy == true
    error_message = "Public zone should have force_destroy enabled"
  }

  assert {
    condition     = aws_route53_zone.private_zone.force_destroy == true
    error_message = "Private zone should have force_destroy enabled"
  }
}
