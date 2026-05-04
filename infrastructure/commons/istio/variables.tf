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

variable "istiod_replica_count" {
  description = <<-EOT
    Number of istiod replicas. When set, the value is forwarded to the Helm
    chart as `pilot.replicaCount`. When `null` (the default), the module
    does NOT pass `pilot.replicaCount` to the chart, preserving the chart's
    own default — this keeps the module backward-compatible for existing
    consumers, who see no behavior change after upgrading.

    Recommended value: `2`. The istiod chart bundles a PodDisruptionBudget
    with `minAvailable=1` and a chart-default `replicaCount=1`. That
    combination yields `allowedDisruptions=0` and blocks every node drain
    on the istiod pod's node — AMI bumps, K8s upgrades, and scale-downs
    all get stuck. Setting this variable to `2` (or higher) lets the PDB
    allow one disruption and keeps drains unblocked.

    Note: when `pilot.autoscaleEnabled=true` (chart default), the istiod
    HPA overrides `replicaCount` after deployment creation. If autoscaling
    is on you should also raise `pilot.autoscaleMin` to >=2; this module
    does not yet expose that value — set `replicaCount` here and override
    `autoscaleMin` separately if needed.
  EOT
  type        = number
  default     = null
}

variable "istiod_version" {
  description = "Helm chart version for istiod (Istio control plane)"
  type        = string
  default     = "1.27.1"
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
