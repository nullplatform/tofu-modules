resource "terraform_data" "provider_validation" {
  lifecycle {
    precondition {
      condition     = var.cloud_provider != "gcp" || length(var.gcp_sa_email) > 0
      error_message = "gcp_sa_email is required when cloud_provider is 'gcp'."
    }
    precondition {
      condition     = var.cloud_provider != "gcp" || length(var.project_id) > 0
      error_message = "project_id is required when cloud_provider is 'gcp'."
    }
    precondition {
      condition     = var.cloud_provider != "aws" || length(var.aws_sa_arn) > 0
      error_message = "aws_sa_arn is required when cloud_provider is 'aws'."
    }
    precondition {
      condition     = var.cloud_provider != "aws" || length(var.aws_region) > 0
      error_message = "aws_region is required when cloud_provider is 'aws'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || !var.azure_workload_identity_enabled || length(var.azure_client_id) > 0
      error_message = "azure_client_id is required when cloud_provider is 'azure' and azure_workload_identity_enabled is true."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || length(var.azure_subscription_id) > 0
      error_message = "azure_subscription_id is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || length(var.azure_resource_group_name) > 0
      error_message = "azure_resource_group_name is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || length(var.azure_tenant_id) > 0
      error_message = "azure_tenant_id is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "azure" || length(var.azure_hosted_zone_name) > 0
      error_message = "azure_hosted_zone_name is required when cloud_provider is 'azure'."
    }
    precondition {
      condition     = var.cloud_provider != "cloudflare" || length(var.cloudflare_token) > 0
      error_message = "cloudflare_token is required when cloud_provider is 'cloudflare'."
    }
    precondition {
      condition     = var.cloud_provider != "oci" || length(var.oci_compartment_ocid) > 0
      error_message = "oci_compartment_ocid is required when cloud_provider is 'oci'."
    }
    precondition {
      condition     = var.cloud_provider != "oci" || length(var.oci_region) > 0
      error_message = "oci_region is required when cloud_provider is 'oci'."
    }
  }
}
