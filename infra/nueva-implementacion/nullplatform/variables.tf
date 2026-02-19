# =============================================================================
# Common Variables (from common.tfvars)
# =============================================================================

variable "np_api_key" {
  type        = string
  description = "Nullplatform API key for provider authentication"
  sensitive   = true
}

variable "nrn" {
  type        = string
  description = "Nullplatform Resource Name"
}

# =============================================================================
# Scope Definition Variables
# =============================================================================

variable "service_path" {
  type        = string
  description = "Service path for scope definition template"
  default     = "k8s"
}

# =============================================================================
# Dimensions Variables
# =============================================================================

variable "environments" {
  type        = list(string)
  description = "List of environment dimension values"
  default     = ["development", "staging", "production"]
}
