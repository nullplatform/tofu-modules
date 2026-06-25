variable "scope_manager_assume_role" {
  description = "ARN of the IAM role for scope and deploy manager"
  type        = string
  default     = "arn:aws:iam::283477532906:role/scope_and_deploy_manager"
}

variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "include_environment" {
  description = "Whether to use Environment as a default dimension"
  type        = bool
  default     = true
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
