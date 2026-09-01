mock_provider "helm" {}

variables {
  cloud_provider       = "aws"
  hosted_zone_name     = "myorg.example.com"
  account_slug         = "myorg"
  private_domain_name  = "myorg.example.com"
  aws_sa_arn           = "arn:aws:iam::123456789012:role/cert-manager"
  aws_region           = "us-east-1"
  cert_manager_version = "v1.21.1"
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

# Validates Pod Identity mode omits the IRSA role-arn annotation
run "aws_pod_identity_omits_role_annotation" {
  command = plan

  variables {
    aws_identity_mode = "pod_identity"
  }

  assert {
    condition     = !contains(keys(local.annotations_by_provider["aws"]), "eks.amazonaws.com/role-arn")
    error_message = "Pod Identity mode must omit the IRSA role-arn annotation"
  }
}

# Validates IRSA mode (default) keeps the role-arn annotation
run "aws_irsa_keeps_role_annotation" {
  command = plan

  assert {
    condition     = local.annotations_by_provider["aws"]["eks.amazonaws.com/role-arn"] == "arn:aws:iam::123456789012:role/cert-manager"
    error_message = "IRSA mode (default) must keep the role-arn annotation"
  }
}

# Validates invalid aws_identity_mode is rejected
run "rejects_invalid_aws_identity_mode" {
  command = plan

  variables {
    aws_identity_mode = "wireguard"
  }

  expect_failures = [var.aws_identity_mode]
}

################################################################################
# Version pinning
################################################################################

# cert_manager_version was declared with a default and never referenced: grep found one
# occurrence, its own declaration. The helm_release had no version argument, so installs
# tracked whatever charts.jetstack.io served while the README showed a number.
run "cert_manager_version_reaches_the_release" {
  command = plan

  assert {
    condition     = helm_release.cert_manager.version == "v1.21.1"
    error_message = "cert_manager_version must be wired to the helm_release, not merely declared"
  }
}
