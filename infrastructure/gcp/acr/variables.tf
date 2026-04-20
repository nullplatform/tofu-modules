###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "location" {
  type        = string
  description = "The GCP region where the container registry will be created (e.g., us-central1, europe-west1)"
}

variable "containerregistry_name" {
  type        = string
  description = "The name of the container registry (repository ID)"
}

###############################################################################
# OPTIONAL VARIABLES - REGISTRY CONFIGURATION
###############################################################################

variable "format" {
  type        = string
  description = "The format of the repository (DOCKER, NPM, PYTHON, etc)"
  default     = "DOCKER"
}

###############################################################################
# OPTIONAL VARIABLES - TAGS AND METADATA
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of labels to assign to the container registry"
  default     = {}
}

variable "workload_identity_bindings" {
  description = "Kubernetes ServiceAccounts allowed to impersonate the GCP Service Account via Workload Identity. Each entry grants roles/iam.workloadIdentityUser on the GSA to the KSA identified by namespace/ksa_name."
  type = list(object({
    namespace = string
    ksa_name  = string
  }))
  default = []
}
