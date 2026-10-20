###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the managed identity will be created"
}

variable "location" {
  type        = string
  description = "The Azure region where the managed identity will be created"
}

variable "name" {
  type        = string
  description = "The name of the user-assigned managed identity"
}

variable "oidc_issuer_url" {
  type        = string
  description = "The OIDC issuer URL of the AKS cluster for federated identity"
}

variable "namespace" {
  type        = string
  description = "The Kubernetes namespace of the service account to federate"
}

variable "service_account_name" {
  type        = string
  description = "The Kubernetes service account name to federate with the managed identity"
}

variable "role_definition_name" {
  type        = string
  description = "The Azure role definition to assign to the managed identity (e.g., 'DNS Zone Contributor'). Optional: leave null and use role_assignments instead. Must be set together with scope"
  default     = null
}

variable "scope" {
  type        = string
  description = "The scope at which the role assignment is applied (e.g., DNS zone resource ID). Optional: leave null and use role_assignments instead. Must be set together with role_definition_name"
  default     = null
}

###############################################################################
# OPTIONAL VARIABLES
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the managed identity"
  default     = {}
}

variable "role_assignments" {
  type = map(object({
    role_definition_name = string
    scope                = string
  }))
  description = "Additional role assignments for the identity, keyed by a static name of your choice (e.g. \"dns_public\"). Keys must be known at plan time; scopes may be known only after apply"
  default     = {}
  nullable    = false
}
