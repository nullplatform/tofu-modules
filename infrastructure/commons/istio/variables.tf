###############################################################################
# ISTIO CONFIGURATION
###############################################################################

variable "istio_base_version" {
  # example: 1.30.7
  description = "No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the istio-base component"
  type        = string

  validation {
    condition     = var.istio_base_version != "" && !contains(["latest", "main", "master"], lower(var.istio_base_version))
    error_message = "istio_base_version must be a non-empty fixed version, not empty and not a moving reference."
  }
}

variable "istiod_version" {
  # example: 1.30.7
  description = "No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for istiod (Istio control plane)"
  type        = string

  validation {
    condition     = var.istiod_version != "" && !contains(["latest", "main", "master"], lower(var.istiod_version))
    error_message = "istiod_version must be a non-empty fixed version, not empty and not a moving reference."
  }
}

variable "istiod_replicas" {
  description = "Number of istiod replicas. Set to 2+ to avoid PDB blocking node drains. Applied to both pilot.replicaCount and pilot.autoscaleMin to prevent the HPA from scaling back to 1."
  type        = number
  default     = 2

  validation {
    condition     = var.istiod_replicas >= 1
    error_message = "istiod_replicas must be at least 1."
  }
}

###############################################################################
# REPOSITORY CONFIGURATION
###############################################################################

variable "repository" {
  type        = string
  description = "The Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts)."
  default     = "https://istio-release.storage.googleapis.com/charts"
}

###############################################################################
# DEPLOYMENT CONFIGURATION
###############################################################################

variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where Istio will be installed."
  default     = "istio-system"

}
