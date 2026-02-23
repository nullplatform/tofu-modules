mock_provider "helm" {}
mock_provider "kubernetes" {}

variables {
  dns_provider_name      = "oci"
  domain_filters         = "myorg.example.com"
  external_dns_namespace = "external-dns"
  oci_compartment_ocid   = "ocid1.compartment.oc1..aaaaaaaatest"
  oci_region             = "us-ashburn-1"
}

# Validates OCI config plans successfully
run "oci_full_config" {
  command = plan

  assert {
    condition     = helm_release.external_dns.name == "external-dns-public"
    error_message = "Helm release name should include type suffix"
  }
}

# Validates OCI secret is created with config yaml
run "oci_secret_created" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_oci_config) == 1
    error_message = "OCI config secret should be created when provider is oci"
  }
}

# Validates OCI extra args include compartment and zone scope
run "oci_extra_args" {
  command = plan

  assert {
    condition     = contains(local.oci_config.extraArgs, "--oci-compartment-ocid=ocid1.compartment.oc1..aaaaaaaatest")
    error_message = "Extra args should include --oci-compartment-ocid"
  }

  assert {
    condition     = contains(local.oci_config.extraArgs, "--oci-zone-scope=GLOBAL")
    error_message = "Extra args should include --oci-zone-scope with default GLOBAL"
  }
}

# Validates OCI volume mount for config
run "oci_config_volume" {
  command = plan

  assert {
    condition     = local.oci_config.extraVolumes[0].name == "oci-config"
    error_message = "OCI config volume should be named 'oci-config'"
  }

  assert {
    condition     = local.oci_config.extraVolumeMounts[0].mountPath == "/etc/kubernetes/"
    error_message = "OCI config should be mounted at /etc/kubernetes/"
  }
}

# Validates no Cloudflare secret for OCI
run "no_cloudflare_secret_for_oci" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_cloudflare) == 0
    error_message = "Cloudflare secret should not be created for OCI provider"
  }
}

# Validates OCI fails without compartment
run "oci_requires_compartment" {
  command = plan

  variables {
    oci_compartment_ocid = ""
  }

  expect_failures = [var.oci_compartment_ocid]
}

# Validates OCI fails without region
run "oci_requires_region" {
  command = plan

  variables {
    oci_region = ""
  }

  expect_failures = [var.oci_region]
}

# Validates OCI zone scope PRIVATE is propagated
run "oci_zone_scope_private" {
  command = plan

  variables {
    oci_zone_scope = "PRIVATE"
  }

  assert {
    condition     = contains(local.oci_config.extraArgs, "--oci-zone-scope=PRIVATE")
    error_message = "Extra args should include --oci-zone-scope=PRIVATE when set"
  }
}

# Validates OCI zone scope rejects invalid values
run "oci_zone_scope_rejects_invalid" {
  command = plan

  variables {
    oci_zone_scope = "LOCAL"
  }

  expect_failures = [var.oci_zone_scope]
}

# Validates OCI zones cache duration default is in extra args
run "oci_cache_duration_default" {
  command = plan

  assert {
    condition     = contains(local.oci_config.extraArgs, "--oci-zones-cache-duration=30s")
    error_message = "Extra args should include default cache duration of 30s"
  }
}

# Validates OCI zones cache duration custom value
run "oci_cache_duration_custom" {
  command = plan

  variables {
    oci_zones_cache_duration = "1m"
  }

  assert {
    condition     = contains(local.oci_config.extraArgs, "--oci-zones-cache-duration=1m")
    error_message = "Extra args should include custom cache duration"
  }
}

# Validates OCI zones cache duration can be disabled
run "oci_cache_duration_disabled" {
  command = plan

  variables {
    oci_zones_cache_duration = "0s"
  }

  assert {
    condition     = contains(local.oci_config.extraArgs, "--oci-zones-cache-duration=0s")
    error_message = "Extra args should allow disabling cache with 0s"
  }
}

# Validates OCI custom service account name
run "oci_custom_service_account_name" {
  command = plan

  variables {
    oci_service_account_name = "my-custom-sa"
  }

  assert {
    condition     = local.oci_config.serviceAccount.name == "my-custom-sa"
    error_message = "OCI service account name should use custom value"
  }
}

# Validates OCI default service account name
run "oci_default_service_account_name" {
  command = plan

  assert {
    condition     = local.oci_config.serviceAccount.name == "external-dns"
    error_message = "OCI service account name should default to external-dns"
  }

  assert {
    condition     = local.oci_config.serviceAccount.create == true
    error_message = "OCI service account creation should be enabled"
  }
}

# Validates OCI provider name in config
run "oci_provider_name" {
  command = plan

  assert {
    condition     = local.oci_config.provider.name == "oci"
    error_message = "OCI provider name should be 'oci'"
  }
}

# Validates OCI debug env var is configured
run "oci_debug_env_var" {
  command = plan

  assert {
    condition     = local.oci_config.env[0].name == "OCI_GO_SDK_DEBUG"
    error_message = "OCI env should include OCI_GO_SDK_DEBUG"
  }

  assert {
    condition     = local.oci_config.env[0].value == "info"
    error_message = "OCI_GO_SDK_DEBUG should be set to info"
  }
}

# Validates OCI config volume mount is read-only
run "oci_volume_mount_readonly" {
  command = plan

  assert {
    condition     = local.oci_config.extraVolumeMounts[0].readOnly == true
    error_message = "OCI config volume mount should be read-only"
  }
}

# Validates OCI secret metadata
run "oci_secret_metadata" {
  command = plan

  assert {
    condition     = kubernetes_secret_v1.external_dns_oci_config[0].metadata[0].name == "external-dns-config"
    error_message = "OCI secret name should be external-dns-config"
  }

  assert {
    condition     = kubernetes_secret_v1.external_dns_oci_config[0].metadata[0].namespace == "external-dns"
    error_message = "OCI secret should be in the external-dns namespace"
  }
}

# Validates OCI secret YAML content includes region
run "oci_secret_content_region" {
  command = plan

  assert {
    condition     = can(regex("region: us-ashburn-1", kubernetes_secret_v1.external_dns_oci_config[0].data["oci.yaml"]))
    error_message = "OCI secret should contain the configured region"
  }
}

# Validates OCI secret YAML content includes workload identity
run "oci_secret_content_workload_identity" {
  command = plan

  assert {
    condition     = can(regex("useWorkloadIdentity: true", kubernetes_secret_v1.external_dns_oci_config[0].data["oci.yaml"]))
    error_message = "OCI secret should enable workload identity"
  }
}

# Validates OCI secret YAML content includes compartment
run "oci_secret_content_compartment" {
  command = plan

  assert {
    condition     = can(regex("compartment: ocid1.compartment.oc1..aaaaaaaatest", kubernetes_secret_v1.external_dns_oci_config[0].data["oci.yaml"]))
    error_message = "OCI secret should contain the configured compartment OCID"
  }
}

# Validates OCI volume references the correct secret
run "oci_volume_secret_reference" {
  command = plan

  assert {
    condition     = local.oci_config.extraVolumes[0].secret.secretName == "external-dns-config"
    error_message = "OCI volume should reference the external-dns-config secret"
  }
}

# Validates OCI with private type changes release name
run "oci_private_type" {
  command = plan

  variables {
    type = "private"
  }

  assert {
    condition     = helm_release.external_dns.name == "external-dns-private"
    error_message = "Private type should change release name to external-dns-private"
  }
}

# Validates OCI base config inherits custom policy
run "oci_custom_policy" {
  command = plan

  variables {
    policy = "sync"
  }

  assert {
    condition     = local.base_config.policy == "sync"
    error_message = "Base config should reflect custom policy"
  }
}

# Validates OCI base config inherits custom sources
run "oci_custom_sources" {
  command = plan

  variables {
    sources = ["ingress", "service"]
  }

  assert {
    condition     = contains(local.base_config.sources, "ingress")
    error_message = "Base config should include ingress source"
  }

  assert {
    condition     = contains(local.base_config.sources, "service")
    error_message = "Base config should include service source"
  }
}

# Validates OCI domain filter is wrapped in list
run "oci_domain_filter" {
  command = plan

  assert {
    condition     = local.base_config.domainFilters[0] == "myorg.example.com"
    error_message = "Domain filter should be wrapped in a list"
  }
}
