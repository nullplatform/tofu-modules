variable "nullplatform_base_helm_version" {
  description = "Helm chart version for the nullplatform base."
  type        = string
  default     = "2.12.0"
}

variable "namespace" {
  description = "Kubernetes namespace where the agent runs."
  type        = string
  default     = "nullplatform-tools"
}

variable "nrn" {
  description = "The Nullplatform Resource Name (NRN)."
  type        = string
}

variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication (account level)."
}

variable "cloud_provider" {
  type        = string
  description = "Cloud provider (eks, gke, aks, oke)."
  validation {
    condition     = contains(["eks", "gke", "aks", "oke"], var.cloud_provider)
    error_message = "cloud_provider must be one of: eks, gke, aks, oke."
  }
}

variable "aws_region" {
  type        = string
  description = "AWS region where resources will be deployed."
  default     = "us-east-1"
}

variable "install_gateway_v2_crd" {
  type        = bool
  description = "Install Gateway API v2 CRDs."
  default     = false
}

############################################
# TLS
############################################

variable "tls_required" {
  type        = bool
  description = "Whether TLS is required."
  default     = true
}

############################################
# Gateway
############################################

variable "gateway_enabled" {
  type        = bool
  description = "Enable the HTTP gateway."
  default     = false
}

variable "gateway_internal_enabled" {
  type        = bool
  description = "Enable the internal (private) gateway."
  default     = false
}

############################################
# Control Plane
############################################

variable "control_plane_enabled" {
  type        = bool
  description = "Enable the control plane."
  default     = false
}

############################################
# Logging (global flag)
############################################

variable "logging_enabled" {
  type        = bool
  description = "Enable the logging layer."
  default     = true
}

############################################
# Prometheus Exporter
############################################

variable "prometheus_enabled" {
  type        = bool
  description = "Enable the Prometheus exporter."
  default     = true
}

############################################
# GELF
############################################

variable "gelf_enabled" {
  type        = bool
  description = "Enable GELF output."
  default     = false
}

variable "gelf_host" {
  type        = string
  description = "GELF host."
  default     = ""
}

variable "gelf_port" {
  type        = number
  description = "GELF port."
  default     = 12201
}

############################################
# Loki
############################################

variable "loki_enabled" {
  type        = bool
  description = "Enable Loki output."
  default     = false
}

variable "loki_host" {
  type        = string
  description = "Loki host."
  default     = ""
}

variable "loki_port" {
  type        = number
  description = "Loki port."
  default     = 3100
}

variable "loki_user" {
  type        = string
  description = "Loki username (if applicable)."
  default     = ""
}

variable "loki_password" {
  type        = string
  description = "Loki password (if applicable)."
  sensitive   = true
  default     = ""
}

variable "loki_bearer_token" {
  type        = string
  description = "Loki bearer token (if applicable)."
  sensitive   = true
  default     = ""
}

############################################
# Dynatrace
############################################

variable "dynatrace_enabled" {
  type        = bool
  description = "Enable Dynatrace integration."
  default     = false
}

variable "dynatrace_api_key" {
  type        = string
  description = "Dynatrace API key."
  sensitive   = true
  default     = ""
}

variable "dynatrace_environment_id" {
  type        = string
  description = "Dynatrace environment ID."
  default     = ""
}

############################################
# Datadog
############################################

variable "datadog_enabled" {
  type        = bool
  description = "Enable Datadog integration."
  default     = false
}

variable "datadog_api_key" {
  type        = string
  description = "Datadog API key."
  sensitive   = true
  default     = ""
}

variable "datadog_region" {
  type        = string
  description = "Datadog region (e.g., us, eu)."
  default     = ""
}

############################################
# New Relic
############################################

variable "newrelic_enabled" {
  type        = bool
  description = "Enable New Relic integration."
  default     = false
}

variable "newrelic_license_key" {
  type        = string
  description = "New Relic license key."
  sensitive   = true
  default     = ""
}

variable "newrelic_region" {
  type        = string
  description = "New Relic region (e.g., US, EU)."
  default     = ""
}

############################################
# CloudWatch
############################################

variable "cloudwatch_enabled" {
  type        = bool
  description = "Enable CloudWatch (global switch)."
  default     = false
}

variable "cloudwatch_logs_enabled" {
  type        = bool
  description = "Enable log forwarding to CloudWatch."
  default     = false
}

variable "cloudwatch_performance_metrics_enabled" {
  type        = bool
  description = "Enable performance metrics in CloudWatch."
  default     = false
}

variable "cloudwatch_custom_metrics_enabled" {
  type        = bool
  description = "Enable custom metrics in CloudWatch."
  default     = false
}

variable "cloudwatch_access_logs_enabled" {
  type        = bool
  description = "Enable access logs in CloudWatch."
  default     = false
}

############################################
# Metrics Server
############################################

variable "metrics_server_enabled" {
  type        = bool
  description = "Enable the metrics server."
  default     = false
}

############################################
# Gateway API / Gateways
############################################

variable "gateways_enabled" {
  type        = bool
  description = "Enable gateway resources (Helm chart)."
  default     = true
}

variable "gateway_api_enabled" {
  type        = bool
  description = "Enable the Gateway API."
  default     = false
}

variable "gateway_api_crds_install" {
  type        = bool
  description = "Install Gateway API CRDs."
  default     = false
}

############################################
# Image Pull Secrets
############################################

variable "image_pull_secrets_enabled" {
  type        = bool
  description = "Create and use an image pull secret."
  default     = false
}

variable "image_pull_secrets_registry" {
  type        = string
  description = "Registry URL for the image pull secret."
  default     = ""
}

variable "image_pull_secrets_username" {
  type        = string
  description = "Registry username."
  default     = ""
}

variable "image_pull_secrets_password" {
  type        = string
  description = "Registry password or token."
  sensitive   = true
  default     = ""
}
