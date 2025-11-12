variable "prometheus_namespace" {
  description = "Kubernetes namespace where Prometheus will be deployed"
  type        = string
  default     = "prometheus"
}

variable "nrn" {
  description = "Nullplatform Resource Name — unique identifier for resources"
  type        = string
}

variable "np_api_key" {
  description = "nullplatform API key for authentication"
  type        = string
  sensitive   = true
}

variable "nullplatform_port" {
  description = "Port number for nullplatform service communication"
  type        = number
  default     = 2021
}

variable "install_prometheus" {
  description = "value"
  type        = bool
  default     = false

}

variable "prometheus_url" {
  type        = string
  default     = null
}