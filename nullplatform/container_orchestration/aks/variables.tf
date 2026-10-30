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
  description = "The name of the AKS cluster"
  type        = string
}

variable "resource_group" {
  description = "Name of the resource group containing the AKS cluster"
  type        = string
}

variable "namespace_application_default" {
  description = "Default Kubernetes namespace for applications"
  type        = string
  default     = "nullplatform"
}

variable "use_nullplatform_namespace" {
  description = "Namespace parity: when enabled, each nullplatform namespace gets its own Kubernetes namespace (named after its slug, see namespace_strategy) instead of every scope sharing namespace_application_default, which becomes the static namespace for shared objects"
  type        = bool
  default     = false
}

variable "namespace_strategy" {
  description = "How namespace parity names the Kubernetes namespace: np_namespace (the nullplatform namespace slug) or np_account_namespace (<account slug>-<namespace slug>, for clusters shared by several accounts). Empty leaves the scope default (np_namespace)"
  type        = string
  default     = ""

  validation {
    condition     = contains(["", "np_namespace", "np_account_namespace"], var.namespace_strategy)
    error_message = "namespace_strategy must be empty, np_namespace or np_account_namespace."
  }
}

variable "namespace_bootstrap_resources" {
  description = "Extra objects copied from namespace_application_default into each namespace parity namespace, as kind/name. Only networkpolicy, limitrange, resourcequota and configmap; image pull secrets and the traffic manager ConfigMap are always copied"
  type        = list(string)
  default     = []

  validation {
    condition = alltrue([
      for ref in var.namespace_bootstrap_resources :
      can(regex("^(networkpolic(y|ies)|limitranges?|resourcequotas?|configmaps?)/[a-z0-9]([-a-z0-9.]*[a-z0-9])?$", lower(ref)))
    ])
    error_message = "namespace_bootstrap_resources entries must be kind/name with kind networkpolicy, limitrange, resourcequota or configmap."
  }
}

variable "authentication_mode" {
  description = "The type of authentication used to connect the cluster (localAccounts, azureActiveDirectory, localandAAD)"
  type        = string
  default     = ""
}

variable "gateway_namespace" {
  description = "Kubernetes namespace where the gateway is deployed"
  type        = string
  default     = "istio-ingress"
}

variable "public_gateway_name" {
  description = "Name of the public Application Gateway in AKS"
  type        = string
}

variable "private_gateway_name" {
  description = "Name of the private Application Gateway in AKS"
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
  description = "List of secret names to use image pull secrets"
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
