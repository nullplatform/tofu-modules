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
  validation {
    condition     = alltrue([for name in var.additional_public_balancer_names : can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{0,30}[a-zA-Z0-9]$|^[a-zA-Z0-9]$", name))])
    error_message = "ALB names must be 1-32 characters, only alphanumeric and hyphens, and cannot start or end with a hyphen."
  }
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
  validation {
    condition     = alltrue([for name in var.additional_private_balancer_names : can(regex("^[a-zA-Z0-9][a-zA-Z0-9-]{0,30}[a-zA-Z0-9]$|^[a-zA-Z0-9]$", name))])
    error_message = "ALB names must be 1-32 characters, only alphanumeric and hyphens, and cannot start or end with a hyphen."
  }
}

variable "alb_capacity_threshold" {
  description = "Maximum ALB rule usage percentage (50-99). The remaining capacity reserves slots for concurrent deployments. Higher values maximize ALB utilization but increase the risk of hitting the rule limit"
  type        = number
  default     = null
  nullable    = true
  validation {
    condition     = var.alb_capacity_threshold == null || (var.alb_capacity_threshold >= 50 && var.alb_capacity_threshold <= 99)
    error_message = "alb_capacity_threshold must be between 50 and 99."
  }
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
  # example: 1.8.0
  description = "No default: every install pins this deliberately — see VERSIONS.md. Pinned rather than tracking latest: a moving tag means a pod restart can pull a different build with no apply in between. Tag for the traffic manager sidecar container"
  type        = string

  validation {
    condition     = var.traffic_manager_version != "" && !contains(["latest", "main", "master"], lower(var.traffic_manager_version))
    error_message = "traffic_manager_version must be a non-empty fixed version, not empty and not a moving reference."
  }
}

variable "traffic_manager_port" {
  description = "Port the traffic manager sidecar binds inside the pod. Defaults to 80 when unset. Set a different port (10080 recommended) when the cluster does not allow pod-to-pod traffic on port 80, which surfaces as a healthy pod that receives no traffic because kubelet probes are node-local and bypass the filtering. Open the port for pod-to-pod traffic before setting this value"
  type        = number
  default     = null
  nullable    = true
  validation {
    condition     = var.traffic_manager_port == null || (var.traffic_manager_port >= 1 && var.traffic_manager_port <= 65535)
    error_message = "traffic_manager_port must be between 1 and 65535."
  }
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

variable "naming_strategy" {
  description = "How Kubernetes object names are built: 'ids' (e.g. d-123456-789012), 'qualified' (application and scope slugs) or 'custom' (the naming patterns). Existing objects are never renamed. Defaults to 'ids' when unset"
  type        = string
  default     = ""
  validation {
    condition     = contains(["", "ids", "qualified", "custom"], var.naming_strategy)
    error_message = "naming_strategy must be one of: ids, qualified, custom."
  }
}

variable "naming_deployment_pattern" {
  description = "Name pattern for the objects a deployment creates (Deployment, Service, HPA, Secret, PodDisruptionBudget), e.g. {.application.slug}-{.scope.slug}-{.deployment.id}. Read only when naming_strategy is 'custom'"
  type        = string
  default     = ""
  validation {
    condition     = var.naming_deployment_pattern == "" || (length(var.naming_deployment_pattern) <= 200 && can(regex("^[A-Za-z0-9.{}\\[\\]\"_-]+$", var.naming_deployment_pattern)))
    error_message = "naming_deployment_pattern must be at most 200 characters of letters, digits, and . { } [ ] \" _ -"
  }
}

variable "naming_scope_pattern" {
  description = "Name pattern for the objects that outlive a deployment (Ingress, HTTPRoute, serving certificate), e.g. {.application.slug}-{.scope.slug}-{.scope.id}. Read only when naming_strategy is 'custom'. Only applies to scopes created after the change"
  type        = string
  default     = ""
  validation {
    condition     = var.naming_scope_pattern == "" || (length(var.naming_scope_pattern) <= 200 && can(regex("^[A-Za-z0-9.{}\\[\\]\"_-]+$", var.naming_scope_pattern)))
    error_message = "naming_scope_pattern must be at most 200 characters of letters, digits, and . { } [ ] \" _ -"
  }
}
