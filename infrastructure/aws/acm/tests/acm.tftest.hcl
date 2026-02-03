mock_provider "aws" {}

variables {
  zone_id     = "Z1234567890ABC"
  domain_name = "myorg.example.com"
}

run "wildcard_certificate_domain" {
  command = plan

  assert {
    condition     = aws_acm_certificate.cert.domain_name == "*.myorg.example.com"
    error_message = "Certificate domain should be a wildcard: *.domain_name"
  }
}

run "dns_validation_method" {
  command = plan

  assert {
    condition     = aws_acm_certificate.cert.validation_method == "DNS"
    error_message = "Validation method should be DNS"
  }
}

run "empty_sans_by_default" {
  command = plan

  assert {
    condition     = length(var.subject_alternative_names) == 0
    error_message = "Subject alternative names should be empty by default"
  }
}

run "custom_sans" {
  command = plan

  variables {
    subject_alternative_names = ["api.myorg.example.com", "admin.myorg.example.com"]
  }

  assert {
    condition     = length(var.subject_alternative_names) == 2
    error_message = "Should accept custom SANs"
  }
}
