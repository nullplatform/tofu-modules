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
