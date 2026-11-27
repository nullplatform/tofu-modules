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
  description = "Default Kubernetes namespace for applications. Accepts a pattern the k8s scope renders per scope, e.g. {.namespace.slug} for one Kubernetes namespace per nullplatform namespace"
  type        = string
  default     = "nullplatform"
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

variable "service_to_service_enabled" {
  description = "Create a stable in-cluster name per scope ({app}-{scope}.{namespace}.svc.cluster.local), routed through an Istio gateway. Needs the in-cluster gateway of the base chart. Sent as false when null and another service_to_service_* is set, like the API would store it"
  type        = bool
  default     = null
}

variable "service_to_service_mode" {
  description = "'shared' (in-cluster listeners on the private gateway) or 'dedicated' (gateway-in-cluster). Must match the base chart's gateway.inCluster.mode. Sent as 'shared' when unset and another service_to_service_* is set"
  type        = string
  default     = ""
  validation {
    condition     = contains(["", "shared", "dedicated"], var.service_to_service_mode)
    error_message = "service_to_service_mode must be one of: shared, dedicated."
  }
}

variable "service_to_service_gateway_name" {
  description = "Gateway the in-cluster routes attach to. The scope defaults it to the private gateway in 'shared' mode and to gateway-in-cluster in 'dedicated' mode"
  type        = string
  default     = ""
  validation {
    condition     = var.service_to_service_gateway_name == "" || can(regex("^[a-z0-9]([-a-z0-9.]{0,251}[a-z0-9])?$", var.service_to_service_gateway_name))
    error_message = "service_to_service_gateway_name must be a lowercase DNS subdomain of up to 253 characters."
  }
}

variable "service_to_service_listener_prefix" {
  description = "Prefix of the gateway listener per port ('<prefix><port>'). The scope defaults it to 'in-cluster-'"
  type        = string
  default     = ""
  validation {
    condition     = var.service_to_service_listener_prefix == "" || (length(var.service_to_service_listener_prefix) <= 50 && can(regex("^[a-z0-9][-a-z0-9]*$", var.service_to_service_listener_prefix)))
    error_message = "service_to_service_listener_prefix must be at most 50 lowercase letters, digits and '-', starting with a letter or digit."
  }
}

variable "service_to_service_cluster_domain" {
  description = "DNS domain of the cluster. The scope defaults it to 'cluster.local'"
  type        = string
  default     = ""
  validation {
    condition     = var.service_to_service_cluster_domain == "" || can(regex("^[a-z0-9]([-a-z0-9.]{0,251}[a-z0-9])?$", var.service_to_service_cluster_domain))
    error_message = "service_to_service_cluster_domain must be a lowercase DNS subdomain of up to 253 characters."
  }
}

variable "service_to_service_name_pattern" {
  description = "Pattern of the stable name, with the resource naming engine (63 characters, no id appended). The scope defaults it to {.application.slug}-{.scope.slug}. A name is kept once created"
  type        = string
  default     = ""
  validation {
    condition     = var.service_to_service_name_pattern == "" || (length(var.service_to_service_name_pattern) <= 200 && can(regex("^[A-Za-z0-9.{}\\[\\]\"_-]+$", var.service_to_service_name_pattern)))
    error_message = "service_to_service_name_pattern must be at most 200 characters of letters, digits, and . { } [ ] \" _ -"
  }
}


variable "naming_strategy" {
  description = "How Kubernetes object names are built: 'ids' (e.g. d-123456-789012), 'qualified' (application and scope slugs) or 'custom' (the naming patterns). Existing objects are never renamed. Defaults to 'qualified'"
  type        = string
  default     = "qualified"
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
