variable "nrn" {
  description = "NRN where this parameter-storage instance (provider config) is anchored."
  type        = string
}

variable "type" {
  description = "Provider specification slug this configuration targets. Determines which default attribute shape is applied — see README for the supported types and their payloads."
  type        = string

  validation {
    condition     = contains(["aws-secrets-manager"], var.type)
    error_message = "type must be one of: aws-secrets-manager."
  }
}

variable "kms_key_id" {
  description = "aws-secrets-manager only. Customer-managed KMS key ARN or alias. If empty, the default aws/secretsmanager managed key is used."
  type        = string
  default     = ""

  validation {
    condition     = var.type == "aws-secrets-manager" || var.kms_key_id == ""
    error_message = "kms_key_id only applies when type is 'aws-secrets-manager'."
  }
}

variable "applies_to" {
  description = "aws-secrets-manager only. Resource types this parameter storage configuration applies to."
  type        = list(string)
  default     = ["secret"]

  validation {
    condition     = var.type == "aws-secrets-manager" || var.applies_to == ["secret"]
    error_message = "applies_to only applies when type is 'aws-secrets-manager'."
  }
}

variable "dimensions" {
  description = "Dimension values for this instance (e.g. { environment = \"production\" })."
  type        = map(string)
  default     = {}
}
