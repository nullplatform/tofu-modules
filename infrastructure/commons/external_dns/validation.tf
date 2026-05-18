resource "terraform_data" "provider_validation" {
  lifecycle {
    precondition {
      condition     = var.dns_provider_name != "cloudflare" || (var.cloudflare_token != null && length(var.cloudflare_token) > 0)
      error_message = "cloudflare_token is required when dns_provider_name is 'cloudflare'."
    }
    precondition {
      condition     = var.dns_provider_name != "aws" || length(var.aws_region) > 0
      error_message = "aws_region is required when dns_provider_name is 'aws'."
    }
    precondition {
      condition     = var.dns_provider_name != "aws" || length(var.aws_iam_role_arn) > 0
      error_message = "aws_iam_role_arn is required when dns_provider_name is 'aws'."
    }
    precondition {
      condition     = var.dns_provider_name != "aws" || var.zone_id_filter != ""
      error_message = "zone_id_filter is required when dns_provider_name is 'aws'."
    }
    precondition {
      condition     = var.dns_provider_name != "aws" || (var.zone_type != "" && contains(["public", "private"], lower(var.zone_type)))
      error_message = "When dns_provider_name is 'aws', zone_type must be 'public' or 'private'."
    }
    precondition {
      condition     = var.dns_provider_name != "oci" || length(var.oci_compartment_ocid) > 0
      error_message = "oci_compartment_ocid is required when dns_provider_name is 'oci'."
    }
    precondition {
      condition     = var.dns_provider_name != "oci" || var.oci_region != ""
      error_message = "oci_region is required when dns_provider_name is 'oci'."
    }
    precondition {
      condition     = var.dns_provider_name != "azure" || length(var.azure_client_id) > 0
      error_message = "azure_client_id is required when dns_provider_name is 'azure'."
    }
    precondition {
      condition     = var.dns_provider_name != "azure" || var.azure_workload_identity_enabled || length(var.azure_client_secret) > 0
      error_message = "azure_client_secret is required when dns_provider_name is 'azure' and azure_workload_identity_enabled is false."
    }
    precondition {
      condition     = var.dns_provider_name != "azure" || length(var.azure_subscription_id) > 0
      error_message = "azure_subscription_id is required when dns_provider_name is 'azure'."
    }
    precondition {
      condition     = var.dns_provider_name != "azure" || length(var.azure_resource_group) > 0
      error_message = "azure_resource_group is required when dns_provider_name is 'azure'."
    }
    precondition {
      condition     = var.dns_provider_name != "azure" || length(var.azure_tenant_id) > 0
      error_message = "azure_tenant_id is required when dns_provider_name is 'azure'."
    }
  }
}
