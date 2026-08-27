variable "prometheus_version" {
  description = "Helm chart version for the prometheus-community/prometheus chart. The helm_release carried no version at all, so every apply resolved to whatever the repository served latest; the default is the version that resolved to as of 2026-08-27, which keeps behaviour unchanged while removing the drift."
  type        = string
  default     = "29.27.0"
}

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
