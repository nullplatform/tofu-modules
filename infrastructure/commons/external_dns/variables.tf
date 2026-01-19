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

variable "public_hosted_zone_id" {
  description = "The Route53 public hosted zone ID for ExternalDNS to manage (required when dns_provider_name is 'aws')"
  type        = string
  default     = null
  validation {
    condition     = var.dns_provider_name != "aws" || var.public_hosted_zone_id != null
    error_message = "public_hosted_zone_id is required when dns_provider_name is 'aws'."
  }
}

variable "private_hosted_zone_id" {
  description = "The Route53 private hosted zone ID for ExternalDNS to manage (required when dns_provider_name is 'aws')"
  type        = string
  default     = null
  validation {
    condition     = var.dns_provider_name != "aws" || var.private_hosted_zone_id != null
    error_message = "private_hosted_zone_id is required when dns_provider_name is 'aws'."
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

variable "oci_service_account_name" {
  description = "The Kubernetes service account name for OCI Workload Identity"
  type        = string
  default     = "external-dns"
}

###############################################################################
# DNS PROVIDER CONFIGURATION
###############################################################################

variable "dns_provider_name" {
  type        = string
  description = "The DNS provider to use with ExternalDNS "
  validation {
    condition     = contains(["cloudflare", "aws", "oci"], var.dns_provider_name)
    error_message = "dns_provider_name must be either 'cloudflare', 'aws', or 'oci'."
  }
}