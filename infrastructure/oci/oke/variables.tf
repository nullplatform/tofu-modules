variable "compartment_id" {
  description = "OCI compartment ID where the OKE cluster will be created"
  type        = string
}
variable "region" {
  description = "OCI region where the cluster is deployed"
  type        = string
}
variable "existing_vcn_id" {
  description = "ID of the existing VCN to use for the OKE cluster"
  type        = string
}
variable "api_endpoint_subnet_id" {
  description = "Subnet ID for the Kubernetes API endpoint (public subnet)"
  type        = string
}
variable "node_pool_subnet_id" {
  description = "Subnet ID for the worker node pool (private subnet)"
  type        = string
}

variable "home_region" {
  type        = string
  description = "The tenancy's home region"
}

variable "cluster_name" {
  description = "Name of the OKE cluster"
  type        = string
}

variable "service_lb_subnet_id" {
  type        = string
  description = "Subnet ID for service load balancers (typically public subnet)"
}

variable "assign_public_ip_to_control_plane" {
  description = "Whether to assign a public IP to the control plane endpoint"
  type        = bool
  default     = false
}

variable "control_plane_is_public" {
  description = "Whether the control plane endpoint is publicly accessible"
  type        = bool
  default     = false
}

variable "control_plane_nsg_ids" {
  description = "Set of NSG IDs to associate with the control plane"
  type        = set(string)
  default     = ["0.0.0.0/0"]
}

variable "worker_pools" {
  description = "Map of worker pool configurations for the OKE cluster"
  type        = any
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

variable "worker_pool_size" {
  type        = number
  default     = 2
  description = "Default number of worker nodes per pool"
}

variable "kubernetes_version" {
  type        = string
  default     = "v1.34.1"
  description = "Kubernetes version for the OKE cluster"
}

variable "cni_type" {
  type        = string
  default     = "flannel"
  description = "CNI type for the OKE cluster. Valid values: 'flannel' or 'npn' (Native Pod Networking)."
  validation {
    condition     = contains(["flannel", "npn"], var.cni_type)
    error_message = "Accepted values are 'flannel' or 'npn'."
  }
}

variable "pod_subnet_id" {
  type        = string
  default     = ""
  description = "Subnet ID for pod networking (required when cni_type = 'npn')."
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
