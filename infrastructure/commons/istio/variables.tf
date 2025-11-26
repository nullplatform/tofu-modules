###############################################################################
# ISTIO CONFIGURATION
###############################################################################

variable "istio_base_version" {
  type    = string
  default = "1.27.1"

}

variable "istio_ingressgateway_version" {
  type    = string
  default = "1.27.1"

}

variable "istiod_version" {
  type    = string
  default = "1.27.1"

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