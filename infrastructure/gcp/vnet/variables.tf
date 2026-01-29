###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "vpc_name" {
  type        = string
  description = "The name of the virtual private network"
}

variable "subnets_definition" {
  type = list(object({
    name           = string
    address_prefix = string
    location       = string
  }))
  description = "List of subnets to create within the virtual network"
}

###############################################################################
# OPTIONAL VARIABLES - KUBERNETES CONFIGURATION
###############################################################################

variable "secondary_ranges" {
  type        = map(list(object({ range_name = string, ip_cidr_range = string })))
  description = "Secondary IP ranges for GKE pods and services"
  default     = {}
}

###############################################################################
# OPTIONAL VARIABLES - TAGS AND METADATA
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of labels to assign to the virtual network resources"
  default     = {}
}
