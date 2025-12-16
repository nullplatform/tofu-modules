variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "cluster_name" {
  type        = string
  description = "The name of the GKE cluster"
}

variable "region" {
  type        = string
  description = "The region for the GKE cluster"
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network"
}

variable "subnetwork_name" {
  type        = string
  description = "The name of the subnetwork"
}

variable "ip_range_pods" {
  type        = string
  description = "The name of the secondary IP range for pods"
}

variable "ip_range_services" {
  type        = string
  description = "The name of the secondary IP range for services"
}

variable "node_pools" {
  type = list(object({
    name         = string
    machine_type = optional(string, "e2-medium")
    min_count    = optional(number, 1)
    max_count    = optional(number, 3)
    disk_size_gb = optional(number, 100)
  }))
  description = "List of node pools"
  default = [{
    name = "default"
  }]
}

variable "master_authorized_networks" {
  type = list(object({
    cidr_block   = string
    display_name = string
  }))
  description = "List of master authorized networks"
  default     = []
}
