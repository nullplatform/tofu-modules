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
    oci_compartment_ocid = null
  }

  expect_failures = [var.oci_compartment_ocid]
}

# Validates OCI fails without region
run "oci_requires_region" {
  command = plan

  variables {
    oci_region = null
  }

  expect_failures = [var.oci_region]
}
