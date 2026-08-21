mock_provider "helm" {}
mock_provider "kubernetes" {}

variables {
  dns_provider_name         = "google"
  domain_filters            = "myorg.example.com"
  external_dns_namespace    = "external-dns"
  gcp_project_id            = "my-gcp-project"
  gcp_service_account_email = "external-dns@my-gcp-project.iam.gserviceaccount.com"
  zone_type                 = "public"
}

run "google_full_config" {
  command = plan

  assert {
    condition     = helm_release.external_dns.name == "external-dns-public"
    error_message = "Helm release name should include type suffix"
  }
}

run "google_workload_identity_annotation" {
  command = plan

  assert {
    condition     = local.google_config.serviceAccount.annotations["iam.gke.io/gcp-service-account"] == "external-dns@my-gcp-project.iam.gserviceaccount.com"
    error_message = "GCP Workload Identity annotation should match gcp_service_account_email"
  }
}

run "google_project_in_values" {
  command = plan

  assert {
    condition     = contains(local.google_config.extraArgs, "--google-project=my-gcp-project")
    error_message = "extraArgs should include --google-project derived from gcp_project_id"
  }
}

run "google_values_reach_helm_release" {
  command = plan

  assert {
    condition     = local.external_dns_values.provider.name == "google"
    error_message = "external_dns_values should select the google provider config"
  }

  assert {
    condition     = contains(local.external_dns_values.extraArgs, "--google-project=my-gcp-project")
    error_message = "gcp_project_id must reach the chart via external_dns_values.extraArgs as --google-project"
  }
}

run "google_zone_visibility_lowercased" {
  command = plan

  variables {
    zone_type = "Public"
  }

  assert {
    condition     = contains(local.google_config.extraArgs, "--google-zone-visibility=public")
    error_message = "zone_type should be lowercased before being passed as --google-zone-visibility, even when the input has mixed case"
  }
}

run "google_zone_visibility_arg" {
  command = plan

  assert {
    condition     = contains(local.google_config.extraArgs, "--google-zone-visibility=public")
    error_message = "Extra args should include --google-zone-visibility"
  }
}

run "google_private_zone_visibility_arg" {
  command = plan

  variables {
    zone_type = "private"
  }

  assert {
    condition     = contains(local.google_config.extraArgs, "--google-zone-visibility=private")
    error_message = "Extra args should include --google-zone-visibility=private when zone_type is private"
  }
}

run "google_default_service_account_name" {
  command = plan

  assert {
    condition     = local.google_config.serviceAccount.name == "external-dns"
    error_message = "Default GCP service account name should be external-dns"
  }
}

run "google_custom_service_account_name" {
  command = plan

  variables {
    gcp_service_account_name = "external-dns-private"
  }

  assert {
    condition     = local.google_config.serviceAccount.name == "external-dns-private"
    error_message = "Custom gcp_service_account_name should be reflected in serviceAccount.name"
  }
}

run "no_cloudflare_secret_for_google" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_cloudflare) == 0
    error_message = "Cloudflare secret should not be created for google provider"
  }
}

run "no_azure_secret_for_google" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_azure_config) == 0
    error_message = "Azure secret should not be created for google provider"
  }
}

run "no_oci_secret_for_google" {
  command = plan

  assert {
    condition     = length(kubernetes_secret_v1.external_dns_oci_config) == 0
    error_message = "OCI secret should not be created for google provider"
  }
}

run "google_requires_project_id" {
  command = plan

  variables {
    gcp_project_id = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

run "google_requires_service_account_email" {
  command = plan

  variables {
    gcp_service_account_email = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

run "google_requires_zone_type" {
  command = plan

  variables {
    zone_type = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

run "google_rejects_invalid_zone_type" {
  command = plan

  variables {
    zone_type = "internal"
  }

  expect_failures = [terraform_data.provider_validation]
}
