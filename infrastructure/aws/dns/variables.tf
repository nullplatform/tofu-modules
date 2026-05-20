variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}
variable "domain_name" {
  type        = string
  description = "The domain name to be managed"
}

variable "enable_public_zone" {
  type        = bool
  description = "Whether to create the public dns zone. At least one of enable_public_zone or enable_private_zone must be true."
  default     = true

  validation {
    condition     = var.enable_public_zone || var.enable_private_zone
    error_message = "At least one of enable_public_zone or enable_private_zone must be true."
  }
}

variable "enable_private_zone" {
  type        = bool
  description = "Whether to create the private dns zone. At least one of enable_public_zone or enable_private_zone must be true."
  default     = true
}