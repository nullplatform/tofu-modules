variable "compartment_id" {
  type = string
}
variable "region" {
  type = string
}
variable "existing_vcn_id" {
  type = string
}
variable "api_endpoint_subnet_id" {
  type = string
} # Subred Pública
variable "node_pool_subnet_id" {
  type = string
} # Subred Privada

variable "home_region" {
  type        = string
  description = "The tenancy's home region"
}

variable "cluster_name" {
  type = string

}

variable "service_lb_subnet_id" {
  type        = string
  description = "Subnet ID for service load balancers (typically public subnet)"
}

variable "assign_public_ip_to_control_plane" {
  default = false

}

variable "control_plane_is_public" {
  default = false

}
variable "control_plane_nsg_ids" {
  type    = set(string)
  default = ["0.0.0.0/0"]

}