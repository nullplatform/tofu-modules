variable "np_api_key" {
  description = "Nullplatform API key for authentication."
  type        = string
  sensitive   = true
}

variable "nrn" {
  description = "Nullplatform Resource Name (NRN) — unique identifier for the target resource."
  type        = string
}

variable "provider_specification_id" {
  description = "ID of the provider specification (scope configuration type) to associate with."
  type        = string
}

variable "attributes" {
  description = "Configuration attributes matching the provider specification schema."
  type        = any
}

variable "dimensions" {
  description = "Dimension values for this configuration."
  type        = map(string)
  default     = {}
}
