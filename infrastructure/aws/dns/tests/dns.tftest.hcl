mock_provider "aws" {}

variables {
  domain_name         = "myorg.example.com"
  vpc_id              = "vpc-12345678"
  enable_public_zone  = true
  enable_private_zone = true
}

run "public_zone_uses_domain" {
  command = plan

  assert {
    condition     = aws_route53_zone.public_zone[0].name == "myorg.example.com"
    error_message = "Public zone should use the provided domain name"
  }
}

run "private_zone_uses_same_domain" {
  command = plan

  assert {
    condition     = aws_route53_zone.private_zone[0].name == "myorg.example.com"
    error_message = "Private zone should use the same domain name as public"
  }
}

run "both_zones_are_destroy_protected" {
  command = plan

  assert {
    condition     = aws_route53_zone.public_zone[0].force_destroy == false
    error_message = "Public zone must not have force_destroy enabled (protects records against accidental deletion)"
  }

  assert {
    condition     = aws_route53_zone.private_zone[0].force_destroy == false
    error_message = "Private zone must not have force_destroy enabled (protects records against accidental deletion)"
  }
}

run "public_zone_disabled_skips_creation" {
  command = plan

  variables {
    enable_public_zone = false
  }

  assert {
    condition     = length(aws_route53_zone.public_zone) == 0
    error_message = "Public zone must not be created when enable_public_zone is false"
  }

  assert {
    condition     = length(aws_route53_zone.private_zone) == 1
    error_message = "Private zone should still be created when only public zone is disabled"
  }
}

run "private_zone_disabled_skips_creation" {
  command = plan

  variables {
    enable_private_zone = false
  }

  assert {
    condition     = length(aws_route53_zone.private_zone) == 0
    error_message = "Private zone must not be created when enable_private_zone is false"
  }

  assert {
    condition     = length(aws_route53_zone.public_zone) == 1
    error_message = "Public zone should still be created when only private zone is disabled"
  }
}

run "rejects_when_both_zones_disabled" {
  command = plan

  variables {
    enable_public_zone  = false
    enable_private_zone = false
  }

  expect_failures = [var.enable_public_zone]
}
