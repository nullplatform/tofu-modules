###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "location" {
  type        = string
  description = "The GCP region where Cloud NAT will be created (e.g., us-central1, europe-west1)"
}

variable "vpc_id" {
  type        = string
  description = "The self-link of the virtual network"
}

variable "router_name" {
  type        = string
  description = "The name of the Cloud Router"
}

variable "nat_name" {
  type        = string
  description = "The name of the Cloud NAT"
}

###############################################################################
# OPTIONAL VARIABLES - TAGS AND METADATA
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of labels to assign to the NAT resources"
  default     = {}
}
