mock_provider "helm" {}

# Validates invalid cloud_provider is rejected
run "rejects_invalid_provider" {
  command = plan

  variables {
    cloud_provider = "digitalocean"
  }

  expect_failures = [var.cloud_provider]
}

# Validates default config (no cloud_provider) does not include OCI annotations
run "default_config_no_oci_annotations" {
  command = plan

  assert {
    condition     = !can(regex("oci\\.oraclecloud\\.com/subnet-ids", local.helm_values))
    error_message = "OCI annotation should not be present when cloud_provider is not set"
  }
}

# Validates gcp provider plans successfully without OCI vars
run "gcp_provider_no_oci_vars_required" {
  command = plan

  variables {
    cloud_provider = "gcp"
  }

  assert {
    condition     = !can(regex("oci\\.oraclecloud\\.com/subnet-ids", local.helm_values))
    error_message = "OCI annotation should not be present for gcp provider"
  }
}

# Validates aws provider plans successfully without OCI vars
run "aws_provider_no_oci_vars_required" {
  command = plan

  variables {
    cloud_provider = "aws"
  }

  assert {
    condition     = !can(regex("oci\\.oraclecloud\\.com/subnet-ids", local.helm_values))
    error_message = "OCI annotation should not be present for aws provider"
  }
}

# Validates azure provider plans successfully without OCI vars
run "azure_provider_no_oci_vars_required" {
  command = plan

  variables {
    cloud_provider = "azure"
  }

  assert {
    condition     = !can(regex("oci\\.oraclecloud\\.com/subnet-ids", local.helm_values))
    error_message = "OCI annotation should not be present for azure provider"
  }
}
