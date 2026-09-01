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
    # PER ZONE. This module creates regional clusters (location is passed as
    # region), so the effective cluster-wide count is these values multiplied by
    # the number of zones in the region — three, in most regions. Use
    # total_min_count/total_max_count instead to express cluster-wide bounds.
    min_count = optional(number, 1)
    max_count = optional(number, 3)
    # PER ZONE, same multiplication as above. Only used when autoscaling is false.
    node_count = optional(number, 1)
    # Cluster-wide autoscaling bounds. When set, they replace the per-zone
    # min_count/max_count. Must be set together.
    total_min_count = optional(number)
    total_max_count = optional(number)
    # spot and preemptible are mutually exclusive lower-cost VM options;
    # leave both false for regular on-demand nodes. Note that GKE does NOT taint
    # spot nodes in standard clusters — it only labels them — so any pod without
    # a nodeSelector can land on preemptible capacity. Use node_pools_taints to
    # keep workloads off them.
    spot        = optional(bool, false)
    preemptible = optional(bool, false)
  }))
  description = "List of node pools to create in the GKE cluster (ignored when autopilot_enabled is true). min_count, max_count and node_count are PER ZONE and the cluster is regional, so they are multiplied by the number of zones in the region; use total_min_count/total_max_count for cluster-wide bounds"
  default = [{
    name = "default"
  }]

  validation {
    condition     = alltrue([for pool in var.node_pools : !(pool.spot && pool.preemptible)])
    error_message = "Each node pool must not set both spot and preemptible to true — they are mutually exclusive lower-cost VM options."
  }

  validation {
    condition = alltrue([
      for pool in var.node_pools :
      (pool.total_min_count == null) == (pool.total_max_count == null)
    ])
    error_message = "total_min_count and total_max_count must be set together: setting only one leaves the other bound per-zone, which silently mixes the two scales."
  }
}

variable "node_pools_taints" {
  type = map(list(object({
    key    = string
    value  = string
    effect = string
  })))
  description = "Node taints by node-pool name, plus an optional 'all' key applied to every pool. Needed to keep ordinary workloads off spot/preemptible pools: GKE adds only labels to Spot nodes in standard clusters, and applies the cloud.google.com/gke-spot NoSchedule taint solely through node auto-provisioning, which is not this path. Pools absent from the map get no taints"
  default     = {}
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
