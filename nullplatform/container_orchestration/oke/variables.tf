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
  description = "OKE cluster name"
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

variable "region" {
  description = "OCI region where the OKE cluster is deployed"
  type        = string
}

variable "gateway_namespace" {
  description = "Kubernetes namespace where the gateway is deployed"
  type        = string
  default     = "gateways"
}

variable "public_gateway_name" {
  description = "Name of the public gateway"
  type        = string
  default     = "public-gateway"
}

variable "private_gateway_name" {
  description = "Name of the private gateway"
  type        = string
  default     = "private-gateway"
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
