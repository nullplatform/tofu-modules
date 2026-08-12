###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
}

variable "location" {
  type        = string
  description = "The GCP region where the GKE cluster will be deployed (e.g., us-central1, europe-west1)"
}

variable "vpc_name" {
  type        = string
  description = "The name of the virtual private network"
}

variable "vpc_subnet_name" {
  type        = string
  description = "The name of the subnet where GKE nodes will be deployed"
}

variable "ip_range_pods" {
  type        = string
  description = "The name of the secondary IP range for pods"
}

variable "ip_range_services" {
  type        = string
  description = "The name of the secondary IP range for services"
}

###############################################################################
# OPTIONAL VARIABLES - AUTOPILOT
###############################################################################

variable "autopilot_enabled" {
  type        = bool
  description = "Create a GKE Autopilot cluster instead of a standard cluster with manually managed node pools. When true, node_pools is ignored — Autopilot provisions and scales nodes automatically per workload."
  default     = false
}

###############################################################################
# OPTIONAL VARIABLES - NODE POOLS (ignored when autopilot_enabled is true)
###############################################################################

variable "node_pools" {
  type = list(object({
    name         = string
    machine_type = optional(string, "e2-medium")
    disk_size_gb = optional(number, 100)
    # When autoscaling is true (the default), the pool scales between
    # min_count and max_count. When false, it holds a fixed node_count.
    autoscaling = optional(bool, true)
    min_count   = optional(number, 1)
    max_count   = optional(number, 3)
    node_count  = optional(number, 1)
    # spot and preemptible are mutually exclusive lower-cost VM options;
    # leave both false for regular on-demand nodes.
    spot        = optional(bool, false)
    preemptible = optional(bool, false)
  }))
  description = "List of node pools to create in the GKE cluster (ignored when autopilot_enabled is true)"
  default = [{
    name = "default"
  }]

  validation {
    condition     = alltrue([for pool in var.node_pools : !(pool.spot && pool.preemptible)])
    error_message = "Each node pool must not set both spot and preemptible to true — they are mutually exclusive lower-cost VM options."
  }
}

variable "authorized_ip_ranges" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "List of authorized IP ranges allowed to access the Kubernetes API server"
  default     = []
}

variable "master_ipv4_cidr_block" {
  type        = string
  description = "The IP range in CIDR notation for the hosted master network (e.g., 172.16.0.0/28)"
  default     = "172.16.0.0/28"
}

variable "deletion_protection_enabled" {
  type        = bool
  description = "Whether to enable deletion protection for the GKE cluster"
  default     = false
}

###############################################################################
# OPTIONAL VARIABLES - TAGS AND METADATA
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of labels to assign to the GKE cluster and related resources"
  default     = {}
}
