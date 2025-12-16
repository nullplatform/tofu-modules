variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "region" {
  type        = string
  description = "The region for Cloud NAT"
}

variable "network_id" {
  type        = string
  description = "The self-link of the VPC network"
}

variable "router_name" {
  type        = string
  description = "The name of the Cloud Router"
}

variable "nat_name" {
  type        = string
  description = "The name of the Cloud NAT"
}
