###############################################################################
# EXTERNAL-DNS CONFIGURATION
###############################################################################

variable "external_dns_version" {
  description = "The version of ExternalDNS Helm chart to deploy"
  type        = string
  default     = "1.19.0"
}

variable "external_dns_namespace" {
  description = "The Kubernetes namespace where ExternalDNS will be deployed"
  type        = string
  default     = "external-dns"
}

variable "domain_filters" {
  description = "The domain filter to limit ExternalDNS to manage DNS records only for specific domains"
  type        = string
}

variable "txt_owner_id" {
  description = "The TXT owner ID used by ExternalDNS to identify DNS records it manages"
  type        = string
  default     = "external_dns"
}

variable "policy" {
  description = "The policy to external dns manage the DNS records"
  type        = string
  default     = "upsert-only"
  validation {
    condition     = contains(["create-only", "sync", "upsert-only"], var.policy)
    error_message = "policy must be either 'create-only', 'sync', 'upsert-only' ."
  }
}

variable "sources" {
  description = "Array contents the sources to external dns work"
  type        = list(string)
  default     = ["crd"]
}

variable "type" {
  description = "Determines whether the external-dns deployment is public or private"
  type        = string
  default     = "public"
  validation {
    condition     = contains(["public", "private"], var.type)
    error_message = "The \"type\" variable must be either \"public\" or \"private\"."
  }
}

###############################################################################
# CLOUDFLARE CONFIGURATION
###############################################################################


variable "cloudflare_token" {
  description = "The Cloudflare API token for DNS management (required when dns_provider_name is 'cloudflare')"
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.dns_provider_name != "cloudflare" || var.cloudflare_token != null
    error_message = "cloudflare_token is required when dns_provider_name is 'cloudflare'."
  }
}

###############################################################################
# AWS CONFIGURATION
###############################################################################

variable "aws_region" {
  description = "The AWS region where the Route53 hosted zones are located"
  type        = string
  default     = null
  validation {
    condition     = var.dns_provider_name != "aws" || var.aws_region != null
    error_message = "aws_region is required when dns_provider_name is 'aws'."
  }
}

variable "aws_iam_role_arn" {
  description = "The IAM role ARN for ExternalDNS to assume for Route53 access (required when dns_provider_name is 'aws')"
  type        = string
  default     = null
  validation {
    condition     = var.dns_provider_name != "aws" || var.aws_iam_role_arn != null
    error_message = "aws_iam_role_arn is required when dns_provider_name is 'aws'."
  }
}

variable "zone_id_filter" {
  description = "The Route53 public or private hosted zone ID for ExternalDNS to manage (required when dns_provider_name is 'aws')"
  type        = string
  default     = ""
  validation {
    condition     = var.dns_provider_name != "aws" || var.zone_id_filter != ""
    error_message = "zone_id_filter is required when dns_provider_name is 'aws'."
  }
}

variable "zone_type" {
  description = "The Route53 hosted zone type for ExternalDNS to manage (public or private)"
  type        = string
  default     = ""
  validation {
    condition = (
    var.dns_provider_name != "aws" || (var.zone_type != "" && contains(["public", "private"], lower(var.zone_type))))
    error_message = "When dns_provider_name is 'aws', zone_type must be 'public' or 'private'."
  }
}

###############################################################################
# AZURE CONFIGURATION
###############################################################################

variable "azure_resource_group" {
  description = "The Azure resource group containing the DNS zone (required when dns_provider_name is 'azure')"
  type        = string
  default     = null
  validation {
    condition     = var.dns_provider_name != "azure" || var.azure_resource_group != null
    error_message = "azure_resource_group is required when dns_provider_name is 'azure'."
  }
}

variable "azure_tenant_id" {
  description = "The Azure tenant ID for authentication (required when dns_provider_name is 'azure')"
  type        = string
  default     = null
  validation {
    condition     = var.dns_provider_name != "azure" || var.azure_tenant_id != null
    error_message = "azure_tenant_id is required when dns_provider_name is 'azure'."
  }
}

variable "azure_subscription_id" {
  description = "The Azure subscription ID containing the DNS zone (required when dns_provider_name is 'azure')"
  type        = string
  default     = null
  validation {
    condition     = var.dns_provider_name != "azure" || var.azure_subscription_id != null
    error_message = "azure_subscription_id is required when dns_provider_name is 'azure'."
  }
}

variable "azure_use_workload_identity" {
  description = "Whether to use Azure Workload Identity for authentication (recommended for AKS)"
  type        = bool
  default     = true
}

variable "azure_client_id" {
  description = "The Azure client ID (application ID) for service principal authentication. Required when azure_use_workload_identity is false."
  type        = string
  default     = null
}

variable "azure_client_secret" {
  description = "The Azure client secret for service principal authentication. Required when azure_use_workload_identity is false."
  type        = string
  sensitive   = true
  default     = null
  validation {
    condition     = var.dns_provider_name != "azure" || var.azure_use_workload_identity == true || (var.azure_client_id != null && var.azure_client_secret != null)
    error_message = "azure_client_id and azure_client_secret are required when dns_provider_name is 'azure' and azure_use_workload_identity is false."
  }
}

###############################################################################
# OCI CONFIGURATION
###############################################################################

variable "oci_compartment_ocid" {
  description = "The OCI compartment OCID where the DNS zones are located (required when dns_provider_name is 'oci')"
  type        = string
  default     = null
  validation {
    condition     = var.dns_provider_name != "oci" || var.oci_compartment_ocid != null
    error_message = "oci_compartment_ocid is required when dns_provider_name is 'oci'."
  }
}

variable "oci_region" {
  description = "The OCI region for workload identity configuration (required when dns_provider_name is 'oci')"
  type        = string
  default     = null
  validation {
    condition     = var.dns_provider_name != "oci" || var.oci_region != null
    error_message = "oci_region is required when dns_provider_name is 'oci'."
  }
}

variable "oci_service_account_name" {
  description = "The Kubernetes service account name for OCI Workload Identity"
  type        = string
  default     = "external-dns"
}

variable "oci_zone_scope" {
  description = "The scope of the DNS zones in OCI (GLOBAL or PRIVATE)"
  type        = string
  default     = "GLOBAL"
  validation {
    condition     = contains(["GLOBAL", "PRIVATE"], var.oci_zone_scope)
    error_message = "oci_zone_scope must be either 'GLOBAL' or 'PRIVATE'."
  }
}

variable "oci_zones_cache_duration" {
  description = "The duration to cache OCI DNS zones (e.g., '30s', '1m'). Set to '0s' to disable caching."
  type        = string
  default     = "30s"
}

###############################################################################
# DNS PROVIDER CONFIGURATION
###############################################################################

variable "dns_provider_name" {
  type        = string
  description = "The DNS provider to use with ExternalDNS "
  validation {
    condition     = contains(["cloudflare", "aws", "oci", "azure"], var.dns_provider_name)
    error_message = "dns_provider_name must be either 'cloudflare', 'aws', 'oci', or 'azure'."
  }
}