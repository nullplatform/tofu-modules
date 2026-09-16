variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the configuration"
  type        = string
}

variable "hosted_private_zone_id" {
  description = "Hosted zone ID for private DNS"
  type        = string
}

variable "hosted_public_zone_id" {
  description = "Hosted zone ID for public DNS. Leave empty for private-only installs: when empty it is omitted from the provider config payload (the API rejects an empty string)."
  type        = string
  default     = ""

  validation {
    condition     = var.hosted_public_zone_id == null || var.hosted_public_zone_id == "" || can(regex("^Z[A-Z0-9]{10,}$", var.hosted_public_zone_id))
    error_message = "hosted_public_zone_id must be empty/null for private-only, or a valid Route53 hosted zone ID (^Z[A-Z0-9]{10,}$)."
  }
}

variable "dimensions" {
  description = "Map of dimension values to configure nullplatform"
  type        = map(string)
  default     = {}
}

variable "application_domain" {
  type        = bool
  description = "Add account name in domain"
  default     = false
}

variable "account_id" {
  description = "AWS account ID to register. Asserted by the caller and only format-checked, not verified against any AWS credentials. Leave unset to read it from the AWS provider credentials (aws_caller_identity)."
  type        = string
  default     = null

  validation {
    condition     = var.account_id == null || can(regex("^[0-9]{12}$", var.account_id))
    error_message = "account_id must be a 12-digit AWS account ID, or unset to resolve it from the AWS provider credentials."
  }
}

variable "region" {
  description = "AWS region to register. Asserted by the caller and only format-checked, not verified against the AWS provider. Leave unset to read it from the AWS provider configuration (aws_region)."
  type        = string
  default     = null

  validation {
    condition     = var.region == null || can(regex("^[a-z]{2}(-[a-z]+)+-[0-9]+$", var.region))
    error_message = "region must be a valid AWS region name (e.g. us-east-1, us-gov-west-1), or unset to resolve it from the AWS provider configuration."
  }
}
