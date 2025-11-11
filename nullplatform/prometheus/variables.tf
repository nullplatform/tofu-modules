variable "prometheus_namespace" {
  description = "Kubernetes namespace where Prometheus will be deployed"
  type        = string
  default     = "prometheus"
}

variable "nrn" {
  description = "Nullplatform Resource Name - unique identifier for resources"
  type        = string
}

variable "np_api_key" {
  description = "Nullplatform API key for authentication"
  type        = string
  sensitive   = true
}

variable "nullplatform_port" {
  description = "Port number for Nullplatform service communication"
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
  description = "Prometheus server URL"
  default     = ""
}

variable "dimensions" {
  type        = map(string)
  description = "Value of the dimensions that you need this provider to be visible"
  default     = {}

}