variable "cluster_name" {
  type        = string
  description = "The GKE cluster name, used for naming firewall rules and deriving network."
}

variable "gcp_project_id" {
  type        = string
  description = "The GCP project ID."
}

variable "gcp_region" {
  type        = string
  description = "The GCP region where the GKE cluster is located."
}

variable "gateways_enabled" {
  type        = bool
  description = "Whether public gateways are enabled."
  default     = true
}

variable "gateway_internal_enabled" {
  type        = bool
  description = "Whether the internal (private) gateway is enabled."
  default     = false
}

variable "gcp_network_name" {
  type        = string
  description = "Override: The VPC network name. If empty, derived from cluster."
  default     = ""
}

variable "network_cidr" {
  type        = string
  description = "Override: The network CIDR block. If empty, derived from subnet."
  default     = ""
}
