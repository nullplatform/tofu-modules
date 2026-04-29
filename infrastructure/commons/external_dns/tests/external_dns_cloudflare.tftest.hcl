mock_provider "helm" {}
mock_provider "kubernetes" {}

variables {
  dns_provider_name      = "cloudflare"
  domain_filters         = "myorg.nullimplementation.com"
  external_dns_namespace = "external-dns"
  cloudflare_token       = "fake-cloudflare-token"
}

run "cloudflare_full_config" {
  command = plan

  assert {
    condition     = helm_release.external_dns.name == "external-dns-public"
    error_message = "Helm release name should include type suffix (default: public)"
  }

  assert {
    condition     = helm_release.external_dns.namespace == "external-dns"
    error_message = "Should deploy to external-dns namespace"
  }
}

run "cloudflare_secret_created" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_cloudflare) == 1
    error_message = "Cloudflare secret should be created when provider is cloudflare"
  }
}

run "oci_secret_not_created_for_cloudflare" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_oci_config) == 0
    error_message = "OCI secret should not be created when provider is cloudflare"
  }
}

run "cloudflare_provider_in_values" {
  command = plan

  assert {
    condition     = local.provider_configs["cloudflare"].provider.name == "cloudflare"
    error_message = "Cloudflare config should set provider name to 'cloudflare'"
  }
}

run "cloudflare_requires_token" {
  command = plan

  variables {
    cloudflare_token = null
  }

  expect_failures = [terraform_data.provider_validation]
}
