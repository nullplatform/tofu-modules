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

variable "create_namespace" {
  description = "Whether to create the Kubernetes namespace. Set to false if the namespace already exists (e.g., when deploying multiple instances)"
  type        = bool
  default     = true
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
  default     = "sync"
  validation {
    condition     = contains(["create-only", "sync", "upsert-only"], var.policy)
    error_message = "policy must be either 'create-only', 'sync', 'upsert-only' ."
  }
}

variable "sources" {
  description = "Array contents the sources to external dns work"
  type        = list(string)
  default     = ["crd", "gateway-httproute"]
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
}

###############################################################################
# AWS CONFIGURATION
###############################################################################

variable "aws_region" {
  description = "The AWS region where the Route53 hosted zones are located"
  type        = string
  default     = null
}

variable "aws_iam_role_arn" {
  description = "The IAM role ARN for ExternalDNS to assume for Route53 access (required when dns_provider_name is 'aws')"
  type        = string
  default     = null
}

variable "zone_id_filter" {
  description = "The Route53 public or private hosted zone ID for ExternalDNS to manage (required when dns_provider_name is 'aws')"
  type        = string
  default     = ""
}

variable "zone_type" {
  description = "The Route53 hosted zone type for ExternalDNS to manage (public or private)"
  type        = string
  default     = ""
}

###############################################################################
# OCI CONFIGURATION
###############################################################################

variable "oci_compartment_ocid" {
  description = "The OCI compartment OCID where the DNS zones are located (required when dns_provider_name is 'oci')"
  type        = string
  default     = " "
}

variable "oci_region" {
  description = "The OCI region for workload identity configuration (required when dns_provider_name is 'oci')"
  type        = string
  default     = ""
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

###############################################################################
# AZURE CONFIGURATION
###############################################################################

variable "azure_client_id" {
  description = "Client ID of the Azure Managed Identity for Workload Identity (required when dns_provider_name is 'azure')"
  type        = string
  default     = null
}

variable "azure_subscription_id" {
  description = "Azure subscription ID where the DNS zone is located (required when dns_provider_name is 'azure')"
  type        = string
  default     = null
}

variable "azure_resource_group" {
  description = "Azure resource group containing the DNS zone (required when dns_provider_name is 'azure')"
  type        = string
  default     = null
}

variable "azure_tenant_id" {
  description = "Azure tenant ID (required when dns_provider_name is 'azure')"
  type        = string
  default     = null
}

