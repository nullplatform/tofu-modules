variable "np_api_key" {
  description = "nullplatform API key. The provider is configured at the root."
  type        = string
  sensitive   = true
}

variable "nrn" {
  description = "NRN where this parameter-storage instance (provider config) is anchored."
  type        = string
}

variable "kms_key_id" {
  description = "Customer-managed KMS key ARN or alias. If empty, the default aws/secretsmanager managed key is used."
  type        = string
  default     = ""
}

variable "applies_to" {
  description = "Resource types this parameter storage configuration applies to."
  type        = list(string)
  default     = ["secret"]
}

variable "dimensions" {
  description = "Dimension values for this instance (e.g. { environment = \"production\" })."
  type        = map(string)
  default     = {}
}
