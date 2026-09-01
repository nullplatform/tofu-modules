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
  description = "Override: The VPC network name. If empty, derived from the cluster. Supplying this together with network_cidr skips the cluster and subnetwork lookups entirely, so the caller does not need container.clusters.get or compute.subnetworks.get. Accepts a bare name or a full projects/P/global/networks/N path — google_compute_firewall normalizes either"
  default     = ""
}

variable "network_cidr" {
  type        = string
  description = "Override: The network CIDR block. If empty, derived from the cluster's subnetwork. Supplying it skips the subnetwork lookup. Needed when the derived path cannot be resolved by the caller's credentials, e.g. a Shared VPC subnet in a host project the module cannot read"
  default     = ""
}
