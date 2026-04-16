variable "nrn" {
  description = "Nullplatform NRN (e.g., organization=X:account=Y:namespace=Z)"
  type        = string
}

variable "dimensions" {
  description = "Dimensions for the provider configuration"
  type        = map(any)
  default     = {}
}

variable "cluster_name" {
  description = "The name of the Amazon EKS cluster"
  type        = string
}

variable "namespace_application_default" {
  description = "Default Kubernetes namespace for applications"
  type        = string
  default     = "nullplatform"
}

variable "use_nullplatform_namespace" {
  description = "When enabled, uses the nullplatform system namespace instead of a custom namespace"
  type        = bool
  default     = false
}

variable "public_balancer_name" {
  description = "The name of the public-facing load balancer for external traffic routing"
  type        = string
  default     = ""
}

variable "additional_public_balancer_names" {
  description = "Additional public-facing load balancers to support scope deployments beyond the 100-rule ALB limit"
  type        = list(string)
  default     = []
}

variable "private_balancer_name" {
  description = "The name of the private load balancer for internal traffic routing"
  type        = string
  default     = ""
}

variable "additional_private_balancer_names" {
  description = "Additional private load balancers to support scope deployments beyond the 100-rule ALB limit"
  type        = list(string)
  default     = []
}

variable "alb_capacity_threshold" {
  description = "Maximum ALB rule usage percentage (50-99). The remaining capacity reserves slots for concurrent deployments. Higher values maximize ALB utilization but increase the risk of hitting the rule limit"
  type        = number
  default     = null
  nullable    = true
}

variable "balancer_group_suffix" {
  description = "Suffix added to the ALB name, enabling management across multiple clusters in the same account"
  type        = string
  default     = ""
}

variable "memory_cpu_ratio" {
  description = "Amount of MiB of ram per CPU. Default value is 2048, it means 1 core for every 2 GiB of RAM"
  type        = string
  default     = ""
}

variable "memory_request_to_limit_ratio" {
  description = "Sets the ratio between requested and limit memory. Default value is 1, must be a number greater than or equal to 1"
  type        = string
  default     = ""
}

variable "max_cores_multiplier" {
  description = "Sets the ratio between requested and limit CPU. Default value is 3, must be a number greater than or equal to 1"
  type        = string
  default     = ""
}

variable "max_milicores" {
  description = "Sets the maximum amount of CPU mili cores a pod can use"
  type        = string
  default     = ""
}

variable "image_pull_secrets" {
  description = "List of secret names to use image pull secrets for secure access to private container images"
  type        = list(string)
  default     = []
}

variable "service_account_name" {
  description = "The name of the Kubernetes service account used for deployments"
  type        = string
  default     = ""
}

variable "traffic_manager_version" {
  description = "Tag for the traffic manager sidecar container"
  type        = string
  default     = "latest"
}

variable "object_modifiers" {
  description = "List of modifications to dynamically modify k8s objects"
  type = list(object({
    selector = string
    action   = string
    type     = string
    value    = optional(string, "")
  }))
  default = []
}
