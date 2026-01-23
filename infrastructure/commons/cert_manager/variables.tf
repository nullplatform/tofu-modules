###############################################################################
# CERT-MANAGER PROVIDER
#################################################ß##############################
variable "cloud_provider" {
  description = "The cloud provider to use: gcp, azure, aws, cloudflare, or oci"
  type        = string
  validation {
    condition     = contains(["gcp", "azure", "cloudflare", "aws", "oci"], var.cloud_provider)
    error_message = "Value must be one of: gcp, azure, cloudflare, aws, oci"
  }
}

variable "gcp_sa_email" {
  description = "The GCP service account email for cert-manager"
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "gcp" || length(var.gcp_sa_email) > 0
    error_message = "When cloud_provider is 'gcp', gcp_sa_email must not be empty."
  }
}

variable "project_id" {
  description = "The GCP project ID for cert-manager DNS01 solver"
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "gcp" || length(var.project_id) > 0
    error_message = "When cloud_provider is 'gcp', project_id must not be empty."
  }
}

variable "aws_sa_arn" {
  description = "The AWS IAM role ARN for cert-manager."
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "aws" || length(var.aws_sa_arn) > 0
    error_message = "When cloud_provider is 'aws', aws_sa_arn must not be empty."
  }
}

variable "azure_client_id" {
  description = "The Azure client ID for cert-manager."
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "azure" || length(var.azure_client_id) > 0
    error_message = "When cloud_provider is 'azure', azure_client_id must not be empty."
  }
}


variable "private_domain_name" {
  description = "The private domain name for internal certificate issuance"
  type        = string
}
####################ß###########################################################
# CERT-MANAGER CONFIGURATION
###############################################################################

variable "cert_manager_version" {
  description = "The version of cert-manager Helm chart to deploy"
  type        = string
  default     = "1.18.2"
}

variable "cert_manager_namespace" {
  description = "The Kubernetes namespace where cert-manager will be deployed"
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_config_version" {
  description = "The version of the cert-manager configuration Helm chart"
  type        = string
  default     = "2.29.2"
}

variable "hosted_zone_name" {
  description = "The hosted zone name (if applicable)."
  type        = string
}

variable "account_slug" {
  description = "The nullplatform account slug."
  type        = string
}

###############################################################################
# AZURE CONFIGURATION
###############################################################################


variable "azure_subscription_id" {
  description = "The Azure subscription ID."
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "azure" || length(var.azure_subscription_id) > 0
    error_message = "When cloud_provider is 'azure', azure_subscription_id must not be empty."
  }
}

variable "azure_resource_group_name" {
  description = "The name of the Azure resource group that contains the DNS zone."
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "azure" || length(var.azure_resource_group_name) > 0
    error_message = "When cloud_provider is 'azure', azure_resource_group_name must not be empty."
  }
}

variable "azure_tenant_id" {
  description = "The Azure tenant ID."
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "azure" || length(var.azure_tenant_id) > 0
    error_message = "When cloud_provider is 'azure', azure_tenant_id must not be empty."
  }
}

variable "azure_hosted_zone_name" {
  description = "The hosted zone name in Azure DNS."
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "azure" || length(var.azure_hosted_zone_name) > 0
    error_message = "When cloud_provider is 'azure', azure_hosted_zone_name must not be empty."
  }
}

###############################################################################
# CLOUDFLARE CONFIGURATION
###############################################################################


variable "cloudflare_secret_name" {
  description = "The name of the Kubernetes secret that stores the Cloudflare API token."
  type        = string
  default     = "cloudflare-api-token-secret"
}

variable "cloudflare_token" {
  description = "The Cloudflare API token (minimum permissions: Zone:DNS:Edit and Zone:Read)."
  type        = string
  sensitive   = true
  default     = ""
  validation {
    condition     = var.cloud_provider != "cloudflare" || length(var.cloudflare_token) > 0
    error_message = "When cloud_provider is 'cloudflare', cloudflare_token must not be empty."
  }
}


###############################################################################
# AWS CONFIGURATION
###############################################################################

variable "aws_region" {
  description = "The AWS region."
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "aws" || length(var.aws_region) > 0
    error_message = "When cloud_provider is 'aws', aws_region must not be empty."
  }
}

###############################################################################
# OCI CONFIGURATION
###############################################################################

variable "oci_compartment_ocid" {
  description = "The OCID of the OCI compartment where the DNS zone is located."
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "oci" || length(var.oci_compartment_ocid) > 0
    error_message = "When cloud_provider is 'oci', oci_compartment_ocid must not be empty."
  }
}

variable "oci_region" {
  description = "The OCI region for DNS operations (e.g., us-ashburn-1)."
  type        = string
  default     = ""
  validation {
    condition     = var.cloud_provider != "oci" || length(var.oci_region) > 0
    error_message = "When cloud_provider is 'oci', oci_region must not be empty."
  }
}

variable "oci_sa_ocid" {
  description = "The OCID of the OCI workload identity principal for cert-manager. Optional when using Dynamic Groups with Workload Identity."
  type        = string
  default     = ""
}
##########web hook
variable "cert_manager_webhook_oci_version" {
  type    = string
  default = "1.4.1"
}

variable "cert_manager_webhook_oci_namespace" {
  type    = string
  default = "cert-manager"

}
