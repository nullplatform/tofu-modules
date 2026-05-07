mock_provider "helm" {}

variables {
  cloud_provider      = "aws"
  hosted_zone_name    = "myorg.example.com"
  account_slug        = "myorg"
  private_domain_name = "myorg.example.com"
  aws_sa_arn          = "arn:aws:iam::123456789012:role/cert-manager"
  aws_region          = "us-east-1"
}

# Validates AWS provider config plans successfully
run "aws_full_config" {
  command = plan

  assert {
    condition     = helm_release.cert_manager.namespace == "cert-manager"
    error_message = "cert-manager should deploy to cert-manager namespace"
  }
}

# Validates AWS IRSA annotation is set correctly
run "aws_irsa_annotation" {
  command = plan

  assert {
    condition     = local.annotations_by_provider["aws"]["eks.amazonaws.com/role-arn"] == "arn:aws:iam::123456789012:role/cert-manager"
    error_message = "AWS IRSA annotation should use the sa_arn"
  }
}

# Validates AWS provider_context includes region
run "aws_provider_context" {
  command = plan

  assert {
    condition     = local.provider_context["enabled"] == "true"
    error_message = "AWS provider context should be enabled"
  }

  assert {
    condition     = local.provider_context["region"] == "us-east-1"
    error_message = "Provider context should include region"
  }
}

# Validates AWS fails without sa_arn
run "aws_requires_sa_arn" {
  command = plan

  variables {
    aws_sa_arn = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

# Validates AWS fails without region
run "aws_requires_region" {
  command = plan

  variables {
    aws_region = ""
  }

  expect_failures = [terraform_data.provider_validation]
}
