variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "location" {
  type        = string
  description = "The location for the repository"
}

variable "repository_id" {
  type        = string
  description = "The repository ID (name)"
}

variable "format" {
  type        = string
  description = "The format (DOCKER, NPM, PYTHON, etc)"
  default     = "DOCKER"
}

variable "tags" {
  type        = map(string)
  description = "A mapping of labels to assign to the Artifact Registry repository"
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
