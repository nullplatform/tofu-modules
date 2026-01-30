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

variable "worker_pools" {
  type = any
  default = {
    pool_principal = {
      mode             = "node-pool"
      shape            = "VM.Standard.E4.Flex"
      ocpus            = 2
      memory           = 16
      size             = 2
      boot_volume_size = 50
      image_type       = "platform"
      os               = "Oracle Linux"
      os_version       = "8"
    }
  }
}

variable "worker_cloud_init" {
  description = "Cloud init configuration for worker nodes. See: https://cloudinit.readthedocs.io/en/latest/reference/modules.html"
  type        = list(map(string))
  default     = []
}

# ---------------------------------------------------------
# OCIR (Oracle Container Image Registry) Configuration
# ---------------------------------------------------------
variable "enable_ocir_pull" {
  type        = bool
  default     = false
  description = "Enable IAM policy to allow workloads to pull images from OCIR"
}

variable "ocir_pull_namespaces" {
  type        = list(string)
  default     = []
  description = "List of Kubernetes namespaces allowed to pull from OCIR. If empty, all namespaces in the cluster are allowed."
}

variable "tenancy_id" {
  type        = string
  default     = null
  description = "The tenancy OCID (required when enable_ocir_pull is true)"
}