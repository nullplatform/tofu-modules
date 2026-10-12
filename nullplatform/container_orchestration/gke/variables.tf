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
  description = "The name of the GKE cluster"
  type        = string
}

variable "location" {
  description = "The location where the GKE cluster is deployed (zone or region, e.g., 'us-central1-a', 'us-west1')"
  type        = string
}

variable "namespace_application_default" {
  description = "Default Kubernetes namespace for applications"
  type        = string
  default     = "nullplatform"
}

variable "gateway_namespace" {
  description = "Kubernetes namespace where the gateway is deployed"
  type        = string
  default     = "istio-ingress-system"
}

variable "public_gateway_name" {
  description = "Name of the public gateway"
  type        = string
}

variable "private_gateway_name" {
  description = "Name of the private gateway"
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
  description = "No default: every install pins this deliberately — see VERSIONS.md. Tag for the traffic manager sidecar container"
  type        = string

  validation {
    condition     = var.traffic_manager_version != "" && !contains(["latest", "main", "master"], lower(var.traffic_manager_version))
    error_message = "traffic_manager_version must be a non-empty fixed version, not empty and not a moving reference."
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
