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
  description = "Deprecated and ignored: Prometheus finds the logs-controller through its prometheus.io/scrape pod annotations. Remove it."
  type        = number
  default     = null
}

# The null-platform-metrics job scraped every node on this port, the same exporters the chart's
# kubernetes-pods job already scrapes by annotation, so every nullplatform_* series was doubled.
check "nullplatform_port_deprecated" {
  assert {
    condition     = var.nullplatform_port == null
    error_message = "nullplatform_port is deprecated and ignored: the logs-controller is scraped through its pod annotations. Remove it."
  }
}

variable "prometheus_namespace" {
  description = "Kubernetes namespace where Prometheus will be deployed"
  type        = string
  default     = "prometheus"
}
