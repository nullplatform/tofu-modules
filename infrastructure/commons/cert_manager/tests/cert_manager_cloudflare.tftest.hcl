mock_provider "helm" {}

variables {
  cloud_provider      = "cloudflare"
  hosted_zone_name    = "myorg.nullimplementation.com"
  account_slug        = "myorg"
  private_domain_name = "myorg.nullimplementation.com"
  cloudflare_token    = "fake-cloudflare-token-for-testing"
}

# Validates Cloudflare provider config plans successfully
run "cloudflare_full_config" {
  command = plan

  assert {
    condition     = helm_release.cert_manager.namespace == "cert-manager"
    error_message = "cert-manager should deploy to cert-manager namespace"
  }
}

# Validates Cloudflare provider_context includes secret_name and token
run "cloudflare_provider_context" {
  command = plan

  assert {
    condition     = local.provider_context["enabled"] == "true"
    error_message = "Cloudflare provider context should be enabled"
  }

  assert {
    condition     = local.provider_context["secret_name"] == "cloudflare-api-token-secret"
    error_message = "Provider context should include default secret_name"
  }
}

# Validates Cloudflare fails without token
run "cloudflare_requires_token" {
  command = plan

  variables {
    cloudflare_token = ""
  }

  expect_failures = [var.cloudflare_token]
}

# Validates custom secret name is propagated
run "cloudflare_custom_secret_name" {
  command = plan

  variables {
    cloudflare_secret_name = "my-custom-cf-secret"
  }

  assert {
    condition     = local.provider_context["secret_name"] == "my-custom-cf-secret"
    error_message = "Custom secret name should be propagated to provider context"
  }
}
