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
  description = "The Helm repository URL (e.g., https://blob.istio.io/istio-release/charts)."
  default     = "https://blob.istio.io/istio-release/charts"
}

variable "image_hub" {
  type        = string
  description = "Registry and path Istio images are pulled from, without a tag (e.g., docker.io/istio, or a private mirror such as myregistry.example.com/istio). Sets global.hub, which applies to istiod and to the proxy injected into sidecars and gateways. Null keeps the chart default: docker.io/istio up to 1.29, registry.istio.io/release in 1.30.x, which upstream is decommissioning."
  default     = null

  validation {
    condition     = var.image_hub == null || can(regex("^[^\\s/:]+(:[0-9]+)?(/[^\\s/:]+)+$", var.image_hub))
    error_message = "image_hub must be a registry host plus path with no tag (e.g., docker.io/istio), or null."
  }
}

variable "image_pull_secrets" {
  type        = list(string)
  description = "Names of image pull secrets for istiod and for the proxy injected into sidecars and gateways, for a hub that needs credentials (see image_hub). Sets global.imagePullSecrets. The module does not create them: each must exist in istio-system and in every namespace with injected pods. Empty keeps the chart default."
  default     = []
  nullable    = false

  validation {
    condition     = alltrue([for n in var.image_pull_secrets : can(regex("^[a-z0-9]([-a-z0-9.]*[a-z0-9])?$", n))])
    error_message = "image_pull_secrets must be Kubernetes secret names (lowercase alphanumerics, '-' or '.')."
  }
}

###############################################################################
# DEPLOYMENT CONFIGURATION
###############################################################################

variable "namespace" {
  type        = string
  description = "The Kubernetes namespace where Istio will be installed."
  default     = "istio-system"

}
