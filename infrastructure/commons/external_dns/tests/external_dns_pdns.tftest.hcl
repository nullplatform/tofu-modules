mock_provider "helm" {}
mock_provider "kubernetes" {}

variables {
  dns_provider_name      = "pdns"
  domain_filters         = "dns.example.com"
  external_dns_namespace = "external-dns"
  pdns_server            = "http://192.0.2.10:8081"
  pdns_api_key           = "fake-pdns-api-key"
}

run "pdns_full_config" {
  command = plan

  assert {
    condition     = helm_release.external_dns.name == "external-dns-public"
    error_message = "Helm release name should include type suffix (default: public)"
  }
}

run "pdns_provider_in_values" {
  command = plan

  assert {
    condition     = local.pdns_config.provider.name == "pdns"
    error_message = "pdns config should set provider name to 'pdns'"
  }
}

run "pdns_server_arg" {
  command = plan

  assert {
    condition     = contains(local.pdns_config.extraArgs, "--pdns-server=http://192.0.2.10:8081")
    error_message = "extraArgs should include --pdns-server derived from pdns_server"
  }
}

run "pdns_server_id_defaults_to_localhost" {
  command = plan

  assert {
    condition     = contains(local.pdns_config.extraArgs, "--pdns-server-id=localhost")
    error_message = "pdns_server_id should default to 'localhost'"
  }
}

run "pdns_server_id_override" {
  command = plan

  variables {
    pdns_server_id = "pdns-behind-proxy"
  }

  assert {
    condition     = contains(local.pdns_config.extraArgs, "--pdns-server-id=pdns-behind-proxy")
    error_message = "extraArgs should reflect a custom pdns_server_id"
  }
}

run "pdns_skip_tls_verify_off_by_default" {
  command = plan

  assert {
    condition     = !contains(local.pdns_config.extraArgs, "--pdns-skip-tls-verify")
    error_message = "extraArgs should not include --pdns-skip-tls-verify by default"
  }
}

run "pdns_skip_tls_verify_enabled" {
  command = plan

  variables {
    pdns_skip_tls_verify = true
  }

  assert {
    condition     = contains(local.pdns_config.extraArgs, "--pdns-skip-tls-verify")
    error_message = "extraArgs should include --pdns-skip-tls-verify when enabled"
  }
}

run "pdns_api_key_env_from_secret" {
  command = plan

  assert {
    condition     = local.pdns_config.env[0].name == "EXTERNAL_DNS_PDNS_API_KEY"
    error_message = "The PDNS API key must travel as an env var (kingpin auto-derives EXTERNAL_DNS_PDNS_API_KEY), never as a CLI arg"
  }

  assert {
    condition     = local.pdns_config.env[0].valueFrom.secretKeyRef.name == "external-dns-pdns"
    error_message = "The API key env var should reference the external-dns-pdns secret"
  }
}

run "pdns_secret_created" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_pdns) == 1
    error_message = "PDNS secret should be created when provider is pdns"
  }
}

run "no_cloudflare_secret_for_pdns" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_cloudflare) == 0
    error_message = "Cloudflare secret should not be created for pdns provider"
  }
}

run "no_oci_secret_for_pdns" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_oci_config) == 0
    error_message = "OCI secret should not be created for pdns provider"
  }
}

run "no_rfc2136_secret_for_pdns" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_rfc2136) == 0
    error_message = "RFC2136 secret should not be created for pdns provider"
  }
}

run "pdns_requires_server" {
  command = plan

  variables {
    pdns_server = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

run "pdns_requires_api_key" {
  command = plan

  variables {
    pdns_api_key = ""
  }

  expect_failures = [terraform_data.provider_validation]
}
