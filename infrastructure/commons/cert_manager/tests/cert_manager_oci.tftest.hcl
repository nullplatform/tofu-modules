mock_provider "helm" {}

variables {
  cloud_provider      = "oci"
  hosted_zone_name    = "myorg.example.com"
  account_slug        = "myorg"
  private_domain_name = "myorg.example.com"
  oci_compartment_ocid = "ocid1.compartment.oc1..aaaaaaaatest"
  oci_sa_ocid          = "ocid1.principal.oc1..aaaaaaaatest"
}

# Validates OCI provider config plans successfully
run "oci_full_config" {
  command = plan

  assert {
    condition     = helm_release.cert_manager.namespace == "cert-manager"
    error_message = "cert-manager should deploy to cert-manager namespace"
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

# Validates OCI provider_context includes compartment
run "oci_provider_context" {
  command = plan

  assert {
    condition     = local.provider_context["enabled"] == true
    error_message = "OCI provider context should be enabled"
  }

  assert {
    condition     = local.provider_context["compartment_ocid"] == "ocid1.compartment.oc1..aaaaaaaatest"
    error_message = "Provider context should include compartment_ocid"
  }
}

# Validates OCI fails without compartment_ocid
run "oci_requires_compartment" {
  command = plan

  variables {
    oci_compartment_ocid = ""
  }

  expect_failures = [var.oci_compartment_ocid]
}

# Validates OCI fails without sa_ocid
run "oci_requires_sa_ocid" {
  command = plan

  variables {
    oci_sa_ocid = ""
  }

  expect_failures = [var.oci_sa_ocid]
}
