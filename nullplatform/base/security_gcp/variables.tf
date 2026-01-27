variable "cluster_name" {
  type        = string
  description = "The GKE cluster name."
}

variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID."
}

variable "gcp_region" {
  type        = string
  description = "The GCP region where the GKE cluster is located."
}

variable "gcp_network_name" {
  type        = string
  description = "Override: The VPC network name for firewall rules. If empty, derived from cluster."
  default     = ""
}

variable "network_cidr" {
  type        = string
  description = "Override: The network CIDR block for restricting health check access. If empty, derived automatically from cluster's subnet."
  default     = ""
}

variable "gateways_enabled" {
  type        = bool
  description = "Enable public gateway firewall rules."
  default     = true
}

variable "gateway_internal_enabled" {
  type        = bool
  description = "Enable private gateway firewall rules."
  default     = false
}
