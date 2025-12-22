variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "network_name" {
  type        = string
  description = "The name of the VPC network"
}

variable "subnets" {
  type = list(object({
    subnet_name   = string
    subnet_ip     = string
    subnet_region = string
  }))
  description = "List of subnets to create"
}

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary ranges for GKE pods and services"
  default     = {}
}
