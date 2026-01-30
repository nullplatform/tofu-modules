###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

###############################################################################
# OPTIONAL VARIABLES - SERVICE ACCOUNTS
###############################################################################

variable "service_accounts" {
  type = list(object({
    name         = string
    display_name = optional(string)
    roles        = optional(list(string), [])
  }))
  description = "List of service accounts to create with their roles"
  default     = []
}

###############################################################################
# OPTIONAL VARIABLES - WORKLOAD IDENTITY
###############################################################################

variable "workload_identity_bindings" {
  type = list(object({
    service_account_email = string
    namespace             = string
    ksa_name              = string
  }))
  description = "Workload Identity bindings (GCP Service Account -> Kubernetes Service Account)"
  default     = []
}
