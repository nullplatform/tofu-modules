variable "prometheus_url" {
  description = "URL of the Prometheus instance used for metrics scraping"
  type        = string
  default     = ""

  validation {
    condition     = var.prometheus_url == "" || can(regex("^https?://", var.prometheus_url))
    error_message = "prometheus_url must start with http:// or https:// when set."
  }
}
variable "dimensions" {
  default     = {}
  description = "name of the dimensions"

}

variable "nrn" {
  description = "nullplatform Resource Name — unique identifier for resources"
  type        = string
}

variable "prometheus_namespace" {
  description = "Kubernetes namespace where Prometheus will be deployed"
  type        = string
  default     = "prometheus"
}
