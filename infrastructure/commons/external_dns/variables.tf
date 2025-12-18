###############################################################################
# EXTERNAL-DNS CONFIGURATION
###############################################################################

variable "external_dns_version" {
  type    = string
  default = "1.19.0"

}

variable "external_dns_namespace" {
  type    = string
  default = "external_dns"
}

variable "domain_filters" {
  type = string
}

variable "txt_owner_id" {
  type    = string
  default = "external_dns"

}

variable "policy" {
  description = "The policy to external dns manage the DNS records"
  type = string
  default = "upsert-only"
  validation {
    condition     = contains(["create-only", "sync", "upsert-only"], var.policy)
    error_message = "policy must be either 'create-only', 'sync', 'upsert-only' ."
  }
}

###############################################################################
# CLOUDFLARE CONFIGURATION
###############################################################################


variable "cloudflare_token" {
  type      = string
  sensitive = true
  default   = null
  validation {
    condition     = var.dns_provider_name != "cloudflare" || var.cloudflare_token != null
    error_message = "cloudflare_token is required when dns_provider_name is 'cloudflare'."
  }
}

###############################################################################
# AWS CONFIGURATION
###############################################################################

variable "aws_region" {}

variable "aws_iam_role_arn" {
  default   = null
  validation {
    condition     = var.dns_provider_name != "aws" || var.aws_iam_role_arn != null
    error_message = "aws_iam_role_arn is required when dns_provider_name is 'aws'."
  }
}

variable "hosted_zone_id" {
  default   = null
  validation {
    condition     = var.dns_provider_name != "aws" || var.hosted_zone_id != null
    error_message = "hosted_zone_id is required when dns_provider_name is 'aws'."
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