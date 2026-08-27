mock_provider "helm" {}

variables {
  cert_manager_version = "v1.21.1"
}

# Validates invalid cloud_provider is rejected
run "rejects_invalid_provider" {
  command = plan

  variables {
    cloud_provider      = "digitalocean"
    hosted_zone_name    = "myorg.example.com"
    account_slug        = "myorg"
    private_domain_name = "myorg.example.com"
  }

  expect_failures = [var.cloud_provider]
}

# Validates GCP-specific vars are not required when using Azure
run "gcp_vars_not_required_for_azure" {
  command = plan

  variables {
    cloud_provider                = "azure"
    hosted_zone_name              = "myorg.example.com"
    account_slug                  = "myorg"
    private_domain_name           = "myorg.example.com"
    azure_client_id               = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
    azure_federated_credential_id = "/subscriptions/00000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/cert-manager/federatedIdentityCredentials/cert-manager-federated"
    azure_subscription_id         = "00000000-0000-0000-0000-000000000000"
    azure_resource_group_name     = "rg-test"
    azure_tenant_id               = "11111111-2222-3333-4444-555555555555"
    azure_hosted_zone_name        = "myorg.example.com"
    # gcp_sa_email and project_id intentionally left empty
  }

  # Should pass without GCP vars
  assert {
    condition     = local.provider_context["enabled"] == "true"
    error_message = "Azure config should work without GCP vars"
  }
}

# Validates AWS-specific vars are not required when using Cloudflare
run "aws_vars_not_required_for_cloudflare" {
  command = plan

  variables {
    cloud_provider      = "cloudflare"
    hosted_zone_name    = "myorg.example.com"
    account_slug        = "myorg"
    private_domain_name = "myorg.example.com"
    cloudflare_token    = "fake-token"
    # aws_sa_arn and aws_region intentionally left empty
  }

  assert {
    condition     = local.provider_context["enabled"] == "true"
    error_message = "Cloudflare config should work without AWS vars"
  }
}

# Validates each provider generates different annotations
run "provider_annotations_are_distinct" {
  command = plan

  variables {
    cloud_provider      = "aws"
    hosted_zone_name    = "myorg.example.com"
    account_slug        = "myorg"
    private_domain_name = "myorg.example.com"
    aws_sa_arn          = "arn:aws:iam::123456789012:role/cert-manager"
    aws_region          = "us-east-1"
  }

  # Each provider should have its own annotation key
  assert {
    condition     = contains(keys(local.annotations_by_provider["aws"]), "eks.amazonaws.com/role-arn")
    error_message = "AWS should use eks.amazonaws.com/role-arn annotation"
  }

  assert {
    condition     = contains(keys(local.annotations_by_provider["azure"]), "azure.workload.identity/client-id")
    error_message = "Azure should use azure.workload.identity/client-id annotation"
  }

  assert {
    condition     = contains(keys(local.annotations_by_provider["gcp"]), "iam.gke.io/gcp-service-account")
    error_message = "GCP should use iam.gke.io/gcp-service-account annotation"
  }

  assert {
    condition     = contains(keys(local.annotations_by_provider["oci"]), "oci.oraclecloud.com/workload-identity-principal")
    error_message = "OCI should use oci.oraclecloud.com/workload-identity-principal annotation"
  }
}

# Validates OCI-specific vars are not required when using AWS
run "oci_vars_not_required_for_aws" {
  command = plan

  variables {
    cloud_provider      = "aws"
    hosted_zone_name    = "myorg.example.com"
    account_slug        = "myorg"
    private_domain_name = "myorg.example.com"
    aws_sa_arn          = "arn:aws:iam::123456789012:role/cert-manager"
    aws_region          = "us-east-1"
    # oci_compartment_ocid, oci_region, oci_sa_ocid intentionally left empty
  }

  assert {
    condition     = local.provider_context["enabled"] == "true"
    error_message = "AWS config should work without OCI vars"
  }

  assert {
    condition     = length(helm_release.cert_manager_webhook_oci) == 0
    error_message = "OCI webhook should not be deployed for AWS provider"
  }
}

# Validates OCI webhook is not deployed for non-OCI providers
run "oci_webhook_not_deployed_for_azure" {
  command = plan

  variables {
    cloud_provider                = "azure"
    hosted_zone_name              = "myorg.example.com"
    account_slug                  = "myorg"
    private_domain_name           = "myorg.example.com"
    azure_client_id               = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
    azure_federated_credential_id = "/subscriptions/00000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/cert-manager/federatedIdentityCredentials/cert-manager-federated"
    azure_subscription_id         = "00000000-0000-0000-0000-000000000000"
    azure_resource_group_name     = "rg-test"
    azure_tenant_id               = "11111111-2222-3333-4444-555555555555"
    azure_hosted_zone_name        = "myorg.example.com"
  }

  assert {
    condition     = length(helm_release.cert_manager_webhook_oci) == 0
    error_message = "OCI webhook should not be deployed for Azure provider"
  }
}

# Validates DNS01 recursive nameservers are always configured
run "dns01_nameservers_always_set" {
  command = plan

  variables {
    cloud_provider      = "cloudflare"
    hosted_zone_name    = "myorg.example.com"
    account_slug        = "myorg"
    private_domain_name = "myorg.example.com"
    cloudflare_token    = "fake-token"
  }

  assert {
    condition     = local.cert_manager_values.dns01RecursiveNameservers == "8.8.8.8:53,1.1.1.1:53"
    error_message = "DNS01 recursive nameservers should always be Google + Cloudflare"
  }

  assert {
    condition     = local.cert_manager_values.dns01RecursiveNameserversOnly == true
    error_message = "dns01RecursiveNameserversOnly should be true"
  }
}
