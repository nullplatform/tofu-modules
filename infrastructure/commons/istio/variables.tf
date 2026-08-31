###############################################################################
# ISTIO CONFIGURATION
###############################################################################

variable "istio_base_version" {
  description = "Helm chart version for the istio-base component"
  type        = string
  default     = "1.27.1"
}

variable "istiod_version" {
  description = "Helm chart version for istiod (Istio control plane)"
  type        = string
  default     = "1.27.1"
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
