mock_provider "helm" {}

variables {
  cloud_provider               = "oci"
  oci_load_balancer_subnet_ids = ["ocid1.subnet.oc1..aaaaaaaatest"]
}

# Validates OCI provider config plans successfully
run "oci_full_config" {
  command = plan

  assert {
    condition     = helm_release.istio_ingressgateway.namespace == "istio-system"
    error_message = "Ingress gateway should deploy to istio-system namespace"
  }
}

# Validates OCI subnet annotation is present in rendered helm values
run "oci_annotation_present" {
  command = plan

  assert {
    condition     = can(regex("service\\.beta\\.kubernetes\\.io/oci-load-balancer-subnet1", local.helm_values))
    error_message = "OCI subnet annotation should be present in helm values"
  }
}

# Validates OCI annotation contains the provided subnet OCID
run "oci_annotation_contains_subnet_id" {
  command = plan

  assert {
    condition     = can(regex("ocid1\\.subnet\\.oc1\\.\\.aaaaaaaatest", local.helm_values))
    error_message = "OCI annotation should include the provided subnet OCID"
  }
}

# Validates multiple subnet OCIDs are joined with comma
run "oci_multiple_subnets_joined" {
  command = plan

  variables {
    oci_load_balancer_subnet_ids = ["ocid1.subnet.oc1..aaaaaaaafirst", "ocid1.subnet.oc1..aaaaaaaasecond"]
  }

  assert {
    condition     = can(regex("ocid1\\.subnet\\.oc1\\.\\.aaaaaaaafirst,ocid1\\.subnet\\.oc1\\.\\.aaaaaaaasecond", local.helm_values))
    error_message = "Multiple OCI subnets should be comma-joined in the annotation"
  }
}

# Validates OCI fails without subnet IDs
run "oci_requires_subnet_ids" {
  command = plan

  variables {
    oci_load_balancer_subnet_ids = []
  }

  expect_failures = [terraform_data.provider_validation]
}
