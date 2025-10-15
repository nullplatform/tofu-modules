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


variable "service_type" {
  type        = string
  description = "Service type for the IngressGateway."
  default     = "LoadBalancer"
}

variable "status_port" {
  type        = number
  description = "Status port (status-port)."
  default     = 15021
}

variable "https_port" {
  type        = number
  description = "External HTTPS Service port."
  default     = 443
}

variable "https_target_port" {
  type        = number
  description = "Container targetPort for HTTPS."
  default     = 8443
}

variable "repository" {
  type        = string
  description = "Helm repository URL (e.g., https://istio-release.storage.googleapis.com/charts)."
  default     = "https://istio-release.storage.googleapis.com/charts"
}

variable "namespace" {
  type        = string
  description = "Kubernetes namespace where the gateway will be installed."
  default     = "istio-system"

}

variable "enable_http2" {
  type        = bool
  description = "Whether to expose the http2 (port 80) service."
  default     = false
}

variable "http2_port" {
  type        = number
  description = "Service port for http2 when enabled."
  default     = 80
}

variable "http2_target_port" {
  type        = number
  description = "Target port for http2 when enabled."
  default     = 80
}