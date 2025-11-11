###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "subscription_id" {
  type        = string
  description = "The ID of your Azure Subscription"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where AKS will be created"
}

variable "location" {
  type        = string
  description = "The Azure region where the AKS cluster should be created (e.g., eastus, westus2)"
}

variable "cluster_name" {
  type        = string
  description = "The name of the AKS cluster"
}

variable "vnet_subnet_id" {
  type        = string
  description = "The ID of the subnet where AKS nodes will be deployed"
}

###############################################################################
# OPTIONAL VARIABLES - KUBERNETES CONFIGURATION
###############################################################################

variable "kubernetes_version" {
  type        = string
  description = "The version of Kubernetes to use for the AKS cluster"
  default     = "1.32.7"
}

variable "prefix" {
  type        = string
  description = "Prefix for resources created by the AKS module"
  default     = "aks"
}

###############################################################################
# OPTIONAL VARIABLES - NODE POOLS
###############################################################################

variable "system_pool_vm_size" {
  type        = string
  description = "The VM size for the system node pool (e.g., Standard_D2s_v4, Standard_D4s_v4)"
  default     = "Standard_D2s_v5"
}

variable "user_pool_vm_size" {
  type        = string
  description = "The VM size for the user node pool (e.g., Standard_D2s_v5, Standard_D4s_v5)"
  default     = "Standard_D2s_v5"
}

###############################################################################
# OPTIONAL VARIABLES - NETWORKING & SECURITY
###############################################################################

variable "authorized_ip_ranges" {
  type        = set(string)
  description = "Set of authorized IP ranges to access the Kubernetes API server"
  default     = null
}

variable "private_cluster_enabled" {
  type        = bool
  description = "Enable private cluster mode (API server only accessible via private network)"
  default     = false
}

###############################################################################
# OPTIONAL VARIABLES - IDENTITY & RBAC
###############################################################################

variable "oidc_issuer_enabled" {
  type        = bool
  description = "Enable OIDC issuer for workload identity"
  default     = true
}

###############################################################################
# OPTIONAL VARIABLES - MONITORING
###############################################################################

variable "cluster_log_analytics_workspace_name" {
  type        = string
  description = "The name of the Log Analytics workspace for cluster monitoring"
  default     = null
}

###############################################################################
# OPTIONAL VARIABLES - TAGS & METADATA
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the AKS cluster and related resources"
  default     = {}
}

variable "environment" {
  type        = string
  description = "Environment name for tagging and naming purposes"
  default     = "nullplatform"
}