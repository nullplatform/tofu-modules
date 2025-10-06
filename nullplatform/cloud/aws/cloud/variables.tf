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
  description = "Hosted zone ID for public DNS"
  type        = string
}

variable "dimensions" {
  description = "Map of dimension values to configure Nullplatform"
  type        = map(string)
  default     = {}
}

# NRN Patch Configuration
variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication"
}