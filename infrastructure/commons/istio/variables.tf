###############################################################################
# ISTIO CONFIGURATION
###############################################################################

variable "istio_base_version" {
  description = "Helm chart version for the istio-base component"
  type        = string
  default     = "1.27.1"
}

variable "istio_ingressgateway_version" {
  description = "Helm chart version for the Istio ingress gateway"
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

variable "istio_ingressgateway_replicas" {
  description = "Number of istio-ingressgateway replicas. Set to 2+ to avoid PDB blocking node drains. Applied to both replicaCount and autoscaling.minReplicas to prevent the HPA from scaling back to 1. The Istio gateway Helm chart installs the gateway with a default PodDisruptionBudget (minAvailable=1), so a single replica blocks node rolling updates with PodEvictionFailure — same class of bug as the istiod single-replica issue."
  type        = number
  default     = 2

  validation {
    condition     = var.istio_ingressgateway_replicas >= 1
    error_message = "istio_ingressgateway_replicas must be at least 1."
  }
}

###############################################################################
# SERVICE CONFIGURATION
###############################################################################


variable "service_type" {
  type        = string
  description = "The Kubernetes service type for the Istio ingress gateway"
  default     = "LoadBalancer"
}

variable "status_port" {
  type        = number
  description = "The status port used (status-port)"
  default     = 15021
}

variable "https_port" {
  type        = number
  description = "The external HTTPS service port"
  default     = 443
}

variable "https_target_port" {
  type        = number
  description = "The container target port for HTTPS"
  default     = 8443
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
  description = "The Kubernetes namespace where gateway will be installed."
  default     = "istio-system"

}

###############################################################################
# CLOUD PROVIDER CONFIGURATION
###############################################################################

variable "cloud_provider" {
  type        = string
  description = "The cloud provider where the cluster is running. Used to inject provider-specific LoadBalancer annotations (e.g. oci). Leave empty for generic/on-prem clusters."
  default     = ""
  validation {
    condition     = contains(["", "aws", "oci", "azure", "gcp"], var.cloud_provider)
    error_message = "Value must be one of: '', 'aws', 'oci', 'azure', 'gcp'"
  }
}

###############################################################################
# OCI CONFIGURATION
###############################################################################

variable "oci_load_balancer_subnet_ids" {
  type        = list(string)
  description = "List of OCI subnet OCIDs for the LoadBalancer Service (required when cloud_provider is 'oci')"
  default     = []
}

###############################################################################
# HTTP2 CONFIGURATION
###############################################################################

variable "enable_http2" {
  type        = bool
  description = "Whether to expose the HTTP2 (port 80) service"
  default     = false
}

variable "http2_port" {
  type        = number
  description = "The external service port for HTTP2 when enabled."
  default     = 80
}

variable "http2_target_port" {
  type        = number
  description = "The container target port for HTTP2 when enabled"
  default     = 80
}
