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
  description = "Default Kubernetes namespace for applications. Accepts a pattern the k8s scope renders per scope, e.g. {.namespace.slug} for one Kubernetes namespace per nullplatform namespace"
  type        = string
  default     = "nullplatform"
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
  validation {
    condition     = var.gateway_namespace == "" || can(regex("^[a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?$", var.gateway_namespace))
    error_message = "gateway_namespace must be a lowercase DNS label of up to 63 characters."
  }
}

variable "public_gateway_name" {
  description = "Name of the public Application Gateway in AKS"
  type        = string
  validation {
    condition     = can(regex("^[a-z0-9]([-a-z0-9.]{0,251}[a-z0-9])?$", var.public_gateway_name))
    error_message = "public_gateway_name must be a lowercase DNS subdomain of up to 253 characters."
  }
}

variable "private_gateway_name" {
  description = "Name of the private Application Gateway in AKS"
  type        = string
  default     = ""
  validation {
    condition     = var.private_gateway_name == "" || can(regex("^[a-z0-9]([-a-z0-9.]{0,251}[a-z0-9])?$", var.private_gateway_name))
    error_message = "private_gateway_name must be a lowercase DNS subdomain of up to 253 characters."
  }
}

variable "additional_public_gateways" {
  description = "Extra gateways the HTTPRoute of public scopes is also attached to, besides the public gateway. namespace defaults to the gateway namespace. Every gateway must exist in the cluster"
  type = list(object({
    name      = string
    namespace = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([for gateway in var.additional_public_gateways :
      can(regex("^[a-z0-9]([-a-z0-9.]{0,251}[a-z0-9])?$", gateway.name)) &&
      (gateway.namespace == null || can(regex("^[a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?$", gateway.namespace)))
    ])
    error_message = "Gateway names must be lowercase DNS subdomains (up to 253 characters) and namespaces lowercase DNS labels (up to 63 characters)."
  }
}

variable "additional_private_gateways" {
  description = "Extra gateways the HTTPRoute of private scopes is also attached to, besides the private gateway. namespace defaults to the gateway namespace. Every gateway must exist in the cluster"
  type = list(object({
    name      = string
    namespace = optional(string)
  }))
  default = []
  validation {
    condition = alltrue([for gateway in var.additional_private_gateways :
      can(regex("^[a-z0-9]([-a-z0-9.]{0,251}[a-z0-9])?$", gateway.name)) &&
      (gateway.namespace == null || can(regex("^[a-z0-9]([-a-z0-9]{0,61}[a-z0-9])?$", gateway.namespace)))
    ])
    error_message = "Gateway names must be lowercase DNS subdomains (up to 253 characters) and namespaces lowercase DNS labels (up to 63 characters)."
  }
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
