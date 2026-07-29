variable "np_api_key" {
  description = "Nullplatform API key for authentication."
  type        = string
  sensitive   = true
}

variable "nrn" {
  description = "Nullplatform Resource Name (NRN) — unique identifier for the target resource."
  type        = string
}

variable "cloud_provider" {
  description = "Cloud provider for this static-files scope configuration."
  type        = string
  default     = "aws"

  validation {
    condition     = contains(["aws", "azure"], var.cloud_provider)
    error_message = "cloud_provider must be one of: aws, azure."
  }
}

variable "aws_region" {
  description = "AWS region where resources will be deployed."
  type        = string
}

variable "aws_state_bucket" {
  description = "S3 bucket name for storing OpenTofu state (also used for S3-native state locking)."
  type        = string
}

variable "aws_distribution" {
  description = "CDN distribution for serving static files."
  type        = string
  default     = "cloudfront"

  validation {
    condition     = contains(["cloudfront"], var.aws_distribution)
    error_message = "aws_distribution must be: cloudfront."
  }
}

variable "aws_network" {
  description = "DNS provider for managing records."
  type        = string
  default     = "route53"

  validation {
    condition     = contains(["route53"], var.aws_network)
    error_message = "aws_network must be: route53."
  }
}

variable "aws_hosted_public_zone_id" {
  description = "Public hosted zone ID for DNS records (e.g., Z1234567890ABC)."
  type        = string
}

variable "aws_security" {
  description = "Optional WAF attachment for the CloudFront distribution. Choose 'none' to skip, or 'waf' to attach an existing AWS WAF WebACL."
  type        = string
  default     = "none"

  validation {
    condition     = contains(["none", "waf"], var.aws_security)
    error_message = "aws_security must be one of: none, waf."
  }
}

variable "aws_web_acl_name" {
  description = "Name of an existing AWS WAF WebACL with scope=CLOUDFRONT. Only used when aws_security = \"waf\"."
  type        = string
  default     = ""
}

variable "dimensions" {
  description = "Dimension values for this configuration."
  type        = map(string)
  default     = {}
}
