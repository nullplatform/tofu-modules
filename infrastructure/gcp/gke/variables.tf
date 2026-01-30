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
# OPTIONAL VARIABLES - NODE POOLS
###############################################################################

variable "node_pools" {
  type = list(object({
    name         = string
    machine_type = optional(string, "e2-medium")
    min_count    = optional(number, 1)
    max_count    = optional(number, 3)
    disk_size_gb = optional(number, 100)
  }))
  description = "List of node pools to create in the GKE cluster"
  default = [{
    name = "default"
  }]
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
