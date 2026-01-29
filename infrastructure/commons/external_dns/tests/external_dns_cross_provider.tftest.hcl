mock_provider "helm" {}
mock_provider "kubernetes" {}

# Validates invalid dns_provider_name is rejected
run "rejects_invalid_provider" {
  command = plan

  variables {
    dns_provider_name      = "azure"
    domain_filters         = "myorg.example.com"
    external_dns_namespace = "external-dns"
  }

  expect_failures = [var.dns_provider_name]
}

# Validates invalid policy is rejected
run "rejects_invalid_policy" {
  command = plan

  variables {
    dns_provider_name      = "cloudflare"
    domain_filters         = "myorg.example.com"
    external_dns_namespace = "external-dns"
    cloudflare_token       = "fake-token"
    policy                 = "delete-all"
  }

  expect_failures = [var.policy]
}

# Validates invalid type is rejected
run "rejects_invalid_type" {
  command = plan

  variables {
    dns_provider_name      = "cloudflare"
    domain_filters         = "myorg.example.com"
    external_dns_namespace = "external-dns"
    cloudflare_token       = "fake-token"
    type                   = "internal"
  }

  expect_failures = [var.type]
}

# Validates private type changes helm release name
run "private_type_in_release_name" {
  command = plan

  variables {
    dns_provider_name      = "cloudflare"
    domain_filters         = "myorg.example.com"
    external_dns_namespace = "external-dns"
    cloudflare_token       = "fake-token"
    type                   = "private"
  }

  assert {
    condition     = helm_release.external_dns.name == "external-dns-private"
    error_message = "Private type should change release name to external-dns-private"
  }
}

# Validates base config is consistent across all providers
run "base_config_consistency" {
  command = plan

  variables {
    dns_provider_name      = "cloudflare"
    domain_filters         = "myorg.example.com"
    external_dns_namespace = "external-dns"
    cloudflare_token       = "fake-token"
    policy                 = "sync"
    sources                = ["ingress", "service"]
  }

  assert {
    condition     = local.base_config.policy == "sync"
    error_message = "Base config should reflect custom policy"
  }

  assert {
    condition     = contains(local.base_config.sources, "ingress")
    error_message = "Base config should reflect custom sources"
  }

  assert {
    condition     = local.base_config.domainFilters[0] == "myorg.example.com"
    error_message = "Domain filter should be wrapped in a list"
  }
}

# Validates all provider configs exist in the lookup map
run "all_providers_in_config_map" {
  command = plan

  variables {
    dns_provider_name      = "cloudflare"
    domain_filters         = "myorg.example.com"
    external_dns_namespace = "external-dns"
    cloudflare_token       = "fake-token"
  }

  assert {
    condition     = contains(keys(local.provider_configs), "cloudflare")
    error_message = "provider_configs should contain cloudflare"
  }

  assert {
    condition     = contains(keys(local.provider_configs), "aws")
    error_message = "provider_configs should contain aws"
  }

  assert {
    condition     = contains(keys(local.provider_configs), "oci")
    error_message = "provider_configs should contain oci"
  }
}
