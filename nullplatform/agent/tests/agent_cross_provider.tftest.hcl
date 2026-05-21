mock_provider "helm" {}

variables {
  api_key        = "test-api-key"
  cluster_name   = "test-cluster"
  nrn            = "organization=1:account=2:namespace=3"
  tags_selectors = { env = "test" }
  image_tag      = "latest"
}

# AWS path: EKS role-arn annotation is set on the ServiceAccount; no Azure wiring leaks in.
run "aws_sets_eks_role_arn_annotation" {
  command = plan

  variables {
    cloud_provider   = "aws"
    aws_iam_role_arn = "arn:aws:iam::123456789012:role/agent-role"
  }

  assert {
    condition     = local.service_account_annotations["eks.amazonaws.com/role-arn"] == "arn:aws:iam::123456789012:role/agent-role"
    error_message = "AWS mode must annotate ServiceAccount with eks.amazonaws.com/role-arn"
  }

  assert {
    condition     = !contains(keys(local.service_account_annotations), "azure.workload.identity/client-id")
    error_message = "AWS mode must not set Azure WI annotations"
  }

  assert {
    condition     = length(local.pod_labels) == 0
    error_message = "AWS mode must not set Azure WI pod labels"
  }

  assert {
    condition     = local.cloud_config.aws["AWS_IAM_ROLE_ARN"] == "arn:aws:iam::123456789012:role/agent-role"
    error_message = "AWS mode must inject AWS_IAM_ROLE_ARN into the agent config"
  }
}

run "aws_requires_iam_role_arn" {
  command = plan
  variables {
    cloud_provider = "aws"
    # aws_iam_role_arn left empty
  }
  expect_failures = [terraform_data.cross_variable_validation]
}

# GCP / OCI smoke checks — confirm no Azure SA annotations or WI pod labels are emitted.
run "gcp_does_not_set_any_workload_identity_wiring" {
  command = plan

  variables {
    cloud_provider       = "gcp"
    private_gateway_name = "gcp-private-gw"
  }

  assert {
    condition     = length(local.service_account_annotations) == 0
    error_message = "GCP mode must not set any ServiceAccount annotations from this module"
  }

  assert {
    condition     = length(local.pod_labels) == 0
    error_message = "GCP mode must not set any pod labels from this module"
  }
}

run "oci_does_not_set_any_workload_identity_wiring" {
  command = plan

  variables {
    cloud_provider       = "oci"
    private_gateway_name = "oci-private-gw"
  }

  assert {
    condition     = length(local.service_account_annotations) == 0
    error_message = "OCI mode must not set any ServiceAccount annotations from this module"
  }

  assert {
    condition     = length(local.pod_labels) == 0
    error_message = "OCI mode must not set any pod labels from this module"
  }
}

# Invalid cloud_provider is rejected by the variable validation.
run "rejects_invalid_cloud_provider" {
  command = plan
  variables {
    cloud_provider = "digitalocean"
  }
  expect_failures = [var.cloud_provider]
}
