variable "np_api_key" {
  description = "nullplatform API key for authentication."
  type        = string
  sensitive   = true
}

variable "nrn" {
  description = "NRN where this parameter-storage instance (provider config) is anchored."
  type        = string
}

variable "provider_specification_slug" {
  description = "Slug of the parameter-storage provider specification to associate with. Typically the `slug` output of the parameter_storage_definition module."
  type        = string

  validation {
    condition     = length(trimspace(var.provider_specification_slug)) > 0
    error_message = "provider_specification_slug must not be empty."
  }
}

variable "dimensions" {
  description = "Dimension values for this instance (e.g. { environment = \"production\" })."
  type        = map(string)
  default     = {}
}

variable "attributes" {
  description = "Provider-specific configuration matching the provider specification schema (e.g. sensibility.applies_to, setup.kms_key_id)."
  type        = any
}
