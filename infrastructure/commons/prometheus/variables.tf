variable "prometheus_version" {
  # example: 29.27.0
  description = "No default: every install pins this deliberately — see VERSIONS.md. Helm chart version for the prometheus-community/prometheus chart. The helm_release carried no version at all, so every apply resolved to whatever the repository served latest; the default is the version that resolved to as of 2026-08-27, which keeps behaviour unchanged while removing the drift."
  type        = string

  validation {
    condition     = var.prometheus_version != "" && !contains(["latest", "main", "master"], lower(var.prometheus_version))
    error_message = "prometheus_version must be a non-empty fixed version, not empty and not a moving reference."
  }
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
