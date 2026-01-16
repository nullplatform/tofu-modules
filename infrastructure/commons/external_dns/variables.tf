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
  default = null
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
# DNS PROVIDER CONFIGURATION
###############################################################################

variable "dns_provider_name" {
  type        = string
  description = "The DNS provider to use with ExternalDNS "
  validation {
    condition     = contains(["cloudflare", "aws"], var.dns_provider_name)
    error_message = "dns_provider_name must be either 'cloudflare' or 'aws'."
  }
}