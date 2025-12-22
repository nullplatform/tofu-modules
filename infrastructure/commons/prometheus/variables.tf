variable "nullplatform_port" {
  description = "Port number for nullplatform service communication"
  type        = number
  default     = 2021
}

variable "prometheus_namespace" {
  description = "Kubernetes namespace where Prometheus will be deployed"
  type        = string
  default     = "prometheus"
}
