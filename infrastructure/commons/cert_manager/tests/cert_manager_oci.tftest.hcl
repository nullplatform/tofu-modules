mock_provider "helm" {}

variables {
  cloud_provider       = "oci"
  hosted_zone_name     = "myorg.example.com"
  account_slug         = "myorg"
  private_domain_name  = "myorg.example.com"
  oci_compartment_ocid = "ocid1.compartment.oc1..aaaaaaaatest"
  oci_sa_ocid          = "ocid1.principal.oc1..aaaaaaaatest"
  oci_region           = "us-ashburn-1"
}

# Validates OCI provider config plans successfully
run "oci_full_config" {
  command = plan

  assert {
    condition     = helm_release.cert_manager.namespace == "cert-manager"
    error_message = "cert-manager should deploy to cert-manager namespace"
  }

  assert {
    condition     = helm_release.cert_manager_config.namespace == "cert-manager"
    error_message = "cert-manager-config should deploy to cert-manager namespace"
  }
}

# Validates OCI workload identity annotation
run "oci_workload_identity_annotation" {
  command = plan

  assert {
    condition     = local.annotations_by_provider["oci"]["oci.oraclecloud.com/workload-identity-principal"] == "ocid1.principal.oc1..aaaaaaaatest"
    error_message = "OCI workload identity annotation should use oci_sa_ocid"
  }
}

# Validates OCI provider_context includes all required fields
run "oci_provider_context_complete" {
  command = plan

  assert {
    condition     = local.provider_context["enabled"] == "true"
    error_message = "OCI provider context should be enabled"
  }

  assert {
    condition     = local.provider_context["compartment_ocid"] == "ocid1.compartment.oc1..aaaaaaaatest"
    error_message = "Provider context should include compartment_ocid"
  }

  assert {
    condition     = local.provider_context["region"] == "us-ashburn-1"
    error_message = "Provider context should include region"
  }
}

# Validates OCI fails without compartment_ocid
run "oci_requires_compartment" {
  command = plan

  variables {
    oci_compartment_ocid = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

# Validates OCI fails without region
run "oci_requires_region" {
  command = plan

  variables {
    oci_region = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

# Validates OCI webhook is deployed when cloud_provider is oci
run "oci_webhook_deployed" {
  command = plan

  assert {
    condition     = length(helm_release.cert_manager_webhook_oci) == 1
    error_message = "OCI webhook should be deployed when cloud_provider is oci"
  }

  assert {
    condition     = helm_release.cert_manager_webhook_oci[0].name == "cert-manager-webhook-oci"
    error_message = "OCI webhook release name should be cert-manager-webhook-oci"
  }

  assert {
    condition     = helm_release.cert_manager_webhook_oci[0].namespace == "cert-manager"
    error_message = "OCI webhook should deploy to cert-manager namespace"
  }

  assert {
    condition     = helm_release.cert_manager_webhook_oci[0].version == "1.4.1"
    error_message = "OCI webhook should use default version 1.4.1"
  }
}

# Validates OCI webhook custom version is respected
run "oci_webhook_custom_version" {
  command = plan

  variables {
    cert_manager_webhook_oci_version = "2.0.0"
  }

  assert {
    condition     = helm_release.cert_manager_webhook_oci[0].version == "2.0.0"
    error_message = "OCI webhook should use custom version"
  }
}

# Validates OCI webhook custom namespace is respected
run "oci_webhook_custom_namespace" {
  command = plan

  variables {
    cert_manager_webhook_oci_namespace = "custom-ns"
  }

  assert {
    condition     = helm_release.cert_manager_webhook_oci[0].namespace == "custom-ns"
    error_message = "OCI webhook should use custom namespace"
  }
}

# Validates cert-manager-config depends on cert-manager
run "oci_config_depends_on_cert_manager" {
  command = plan

  assert {
    condition     = helm_release.cert_manager_config.name == "cert-manager-config"
    error_message = "cert-manager-config release should exist"
  }
}

# Validates OCI works without oci_sa_ocid (optional field)
run "oci_sa_ocid_optional" {
  command = plan

  variables {
    oci_sa_ocid = ""
  }

  assert {
    condition     = local.annotations_by_provider["oci"]["oci.oraclecloud.com/workload-identity-principal"] == ""
    error_message = "OCI annotation should be empty when oci_sa_ocid is not provided"
  }

  assert {
    condition     = helm_release.cert_manager.namespace == "cert-manager"
    error_message = "cert-manager should still deploy without oci_sa_ocid"
  }
}

