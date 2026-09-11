variable "nrn" {
  description = "NRN where this parameter-storage instance (provider config) is anchored."
  type        = string
}

variable "type" {
  description = "Provider specification slug this configuration targets. Determines which default attribute shape is applied — see README for the supported types and their payloads."
  type        = string

  validation {
    condition     = contains(["aws-secrets-manager", "aws-parameter-store"], var.type)
    error_message = "type must be one of: aws-secrets-manager, aws-parameter-store."
  }
}

variable "kms_key_id" {
  description = "Customer-managed KMS key ARN or alias. If empty, the service's AWS-managed key is used (aws/secretsmanager for aws-secrets-manager, alias/aws/ssm for aws-parameter-store)."
  type        = string
  default     = ""
}

variable "applies_to" {
  description = "Which parameters this backend stores: any of secret, non_secret. Defaults to the spec's own default for the type — [\"secret\"] for aws-secrets-manager, [\"non_secret\"] for aws-parameter-store."
  type        = list(string)
  default     = null

  validation {
    condition = var.applies_to == null || alltrue([
      for v in coalesce(var.applies_to, []) : contains(["secret", "non_secret"], v)
    ])
    error_message = "applies_to entries must be one of: secret, non_secret."
  }

  validation {
    condition     = var.applies_to == null || length(var.applies_to) > 0
    error_message = "applies_to must list at least one parameter kind when set."
  }
}

variable "tier" {
  description = "aws-parameter-store only. SSM parameter tier: Standard (free up to 10,000 parameters), Advanced (larger values, billed per parameter) or Intelligent-Tiering. Defaults to Standard."
  type        = string
  default     = null

  validation {
    condition     = var.tier == null || contains(["Standard", "Advanced", "Intelligent-Tiering"], var.tier)
    error_message = "tier must be one of: Standard, Advanced, Intelligent-Tiering."
  }

  validation {
    condition     = var.type == "aws-parameter-store" || var.tier == null
    error_message = "tier only applies when type is 'aws-parameter-store'."
  }
}

variable "dimensions" {
  description = "Dimension values for this instance (e.g. { environment = \"production\" })."
  type        = map(string)
  default     = {}
}
