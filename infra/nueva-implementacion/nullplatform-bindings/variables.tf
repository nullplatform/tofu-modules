# =============================================================================
# Common Variables (from common.tfvars)
# =============================================================================

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "aws_profile" {
  type        = string
  description = "AWS CLI profile for authentication"
  default     = null
}

variable "np_api_key" {
  type        = string
  description = "Nullplatform API key for provider authentication"
  sensitive   = true
}

variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name"
}

variable "domain_name" {
  type        = string
  description = "Domain name for cloud provider configuration"
}

variable "backend_bucket" {
  type        = string
  description = "S3 bucket name for Terraform remote state"
}

variable "tags_selectors" {
  type        = map(string)
  description = "Tags selectors for agent channel filtering"
}

# =============================================================================
# GitHub Variables
# =============================================================================

variable "github_organization" {
  type        = string
  description = "GitHub organization name"
}

variable "github_installation_id" {
  type        = string
  description = "GitHub App installation ID"
}
