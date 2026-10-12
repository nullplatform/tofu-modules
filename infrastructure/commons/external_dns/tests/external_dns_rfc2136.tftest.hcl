mock_provider "helm" {}
mock_provider "kubernetes" {}

variables {
  dns_provider_name      = "rfc2136"
  domain_filters         = "dns.example.com"
  external_dns_namespace = "external-dns"
  rfc2136_host           = "192.0.2.10"
  rfc2136_zone           = "dns.example.com"
  rfc2136_tsig_keyname   = "external-dns-key"
  rfc2136_tsig_secret    = "ZmFrZS10c2lnLXNlY3JldA=="
}

run "rfc2136_full_config" {
  command = plan

  assert {
    condition     = helm_release.external_dns.name == "external-dns-public"
    error_message = "Helm release name should include type suffix (default: public)"
  }
}

run "rfc2136_provider_in_values" {
  command = plan

  assert {
    condition     = local.rfc2136_config.provider.name == "rfc2136"
    error_message = "rfc2136 config should set provider name to 'rfc2136'"
  }
}

run "rfc2136_host_and_zone_args" {
  command = plan

  assert {
    condition     = contains(local.rfc2136_config.extraArgs, "--rfc2136-host=192.0.2.10")
    error_message = "extraArgs should include --rfc2136-host derived from rfc2136_host"
  }

  assert {
    condition     = contains(local.rfc2136_config.extraArgs, "--rfc2136-zone=dns.example.com")
    error_message = "extraArgs should include --rfc2136-zone derived from rfc2136_zone"
  }
}

run "rfc2136_port_defaults_to_53" {
  command = plan

  assert {
    condition     = contains(local.rfc2136_config.extraArgs, "--rfc2136-port=53")
    error_message = "rfc2136_port should default to 53"
  }
}

run "rfc2136_tsig_args_by_default" {
  command = plan

  assert {
    condition     = contains(local.rfc2136_config.extraArgs, "--rfc2136-tsig-keyname=external-dns-key")
    error_message = "extraArgs should include the TSIG key name when rfc2136_insecure is false (default)"
  }

  assert {
    condition     = !contains(local.rfc2136_config.extraArgs, "--rfc2136-insecure")
    error_message = "extraArgs should not include --rfc2136-insecure by default"
  }
}

run "rfc2136_insecure_skips_tsig_args" {
  command = plan

  variables {
    rfc2136_insecure     = true
    rfc2136_tsig_keyname = ""
    rfc2136_tsig_secret  = ""
  }

  assert {
    condition     = contains(local.rfc2136_config.extraArgs, "--rfc2136-insecure")
    error_message = "extraArgs should include --rfc2136-insecure when rfc2136_insecure is true"
  }

  assert {
    condition     = length(local.rfc2136_config.env) == 0
    error_message = "No TSIG secret env var should be set when rfc2136_insecure is true"
  }
}

run "rfc2136_tsig_secret_env_from_secret" {
  command = plan

  assert {
    condition     = local.rfc2136_config.env[0].name == "EXTERNAL_DNS_RFC2136_TSIG_SECRET"
    error_message = "The TSIG secret must travel as an env var (kingpin auto-derives EXTERNAL_DNS_RFC2136_TSIG_SECRET)"
  }

  assert {
    condition     = local.rfc2136_config.env[0].valueFrom.secretKeyRef.name == "external-dns-rfc2136"
    error_message = "The TSIG secret env var should reference the external-dns-rfc2136 secret"
  }
}

run "rfc2136_secret_created" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_rfc2136) == 1
    error_message = "RFC2136 secret should be created when provider is rfc2136 and not insecure"
  }
}

run "rfc2136_secret_not_created_when_insecure" {
  command = plan

  variables {
    rfc2136_insecure     = true
    rfc2136_tsig_keyname = ""
    rfc2136_tsig_secret  = ""
  }

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_rfc2136) == 0
    error_message = "RFC2136 secret should not be created when rfc2136_insecure is true"
  }
}

run "no_cloudflare_secret_for_rfc2136" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_cloudflare) == 0
    error_message = "Cloudflare secret should not be created for rfc2136 provider"
  }
}

run "no_pdns_secret_for_rfc2136" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_pdns) == 0
    error_message = "PDNS secret should not be created for rfc2136 provider"
  }
}

run "rfc2136_requires_host" {
  command = plan

  variables {
    rfc2136_host = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

run "rfc2136_requires_zone" {
  command = plan

  variables {
    rfc2136_zone = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

run "rfc2136_requires_tsig_keyname_unless_insecure" {
  command = plan

  variables {
    rfc2136_tsig_keyname = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

run "rfc2136_requires_tsig_secret_unless_insecure" {
  command = plan

  variables {
    rfc2136_tsig_secret = ""
  }

  expect_failures = [terraform_data.provider_validation]
}
