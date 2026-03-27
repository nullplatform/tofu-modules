variable "prometheus_url" {
  description = "URL of the Prometheus instance used for metrics scraping"
  type        = string
  default     = ""
}
variable "dimensions" {
  default     = {}
  description = "name of the dimensions"

}

variable "nrn" {
  description = "nullplatform Resource Name — unique identifier for resources"
  type        = string
}

variable "np_api_key" {
  description = "nullplatform API key for authentication"
  type        = string
  sensitive   = true
}

variable "prometheus_namespace" {
  description = "Kubernetes namespace where Prometheus will be deployed"
  type        = string
  default     = "prometheus"
}
