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
  description = "The Azure role definition to assign to the managed identity (e.g., 'DNS Zone Contributor')"
}

variable "scope" {
  type        = string
  description = "The scope at which the role assignment is applied (e.g., DNS zone resource ID)"
}

###############################################################################
# OPTIONAL VARIABLES
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the managed identity"
  default     = {}
}
