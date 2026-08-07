###############################################################################
# REQUIRED VARIABLES
###############################################################################

# Nothing in this module reads it, so tflint's terraform_unused_declarations
# flags it -- the subscription is selected by the caller's azurerm provider, and
# a module has no business declaring that provider. It is NOT removed: it is
# required (no default), so every caller passes it today and dropping it would
# break them all with "Unsupported argument". Whether the module should keep
# demanding a value it never sends anywhere is a separate, breaking change.
# tflint-ignore: terraform_unused_declarations
variable "subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group where the AKS cluster will be created"
}

variable "location" {
  type        = string
  description = "The Azure region where the AKS cluster will be deployed (e.g., eastus, westus2)"
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
  description = "The prefix for resources created by the AKS module"
  default     = "aks"
}

###############################################################################
# OPTIONAL VARIABLES - NODE POOLS
###############################################################################
#https://learn.microsoft.com/en-us/azure/virtual-machines/sizes
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
# OPTIONAL VARIABLES - NETWORKING AND SECURITY
###############################################################################

variable "authorized_ip_ranges" {
  type        = set(string)
  description = "The set of authorized IP ranges allowed to access the Kubernetes API server"
  default     = null
}

variable "private_cluster_enabled" {
  type        = bool
  description = "Whether to enable private cluster mode (API server accessible only via the private network)"
  default     = false
}

###############################################################################
# OPTIONAL VARIABLES - IDENTITY AND RBAC
###############################################################################

###############################################################################
# OPTIONAL VARIABLES - TAGS AND METADATA
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the AKS cluster and related resources"
  default     = {}
}

# Same story: declared for tagging and naming, never actually merged into `tags`
# or any name, so tflint flags it. Folding it into the tags now would add a tag
# to every cluster already built by this module -- a diff for every consumer --
# and removing it would break the ones that pass it. Left as-is deliberately.
# tflint-ignore: terraform_unused_declarations
variable "environment" {
  type        = string
  description = "The environment name used for tagging and naming purposes"
  default     = "nullplatform"
}

###############################################################################
# OPTIONAL VARIABLES - ACR INTEGRATION
###############################################################################

variable "acr_id" {
  type        = string
  description = "The ID of the Azure Container Registry. If provided, AKS will be granted AcrPull role to pull images."
  default     = null
}

variable "attach_acr" {
  type        = bool
  description = "Whether to grant AKS the AcrPull role on acr_id. Null (default) preserves the legacy behaviour of attaching whenever acr_id is non-null. Set to true for a greenfield single-apply where acr_id is known only after apply (keeps the for_each key set plan-stable); set to false to disable."
  default     = null
}

# ==============================================================================
# Availability zones
#
# `node_pools` in the upstream module (Azure/aks/azurerm) declares the field as
# `zones`. This module passed `availability_zones`, and Terraform DISCARDS
# attributes that are absent from an object({...}) type rather than failing, so
# the value never reached Azure: pools created by this module have no zone
# spread. The system pool had no zones either -- upstream takes those through
# the top-level `agents_availability_zones`, which was never set.
#
# Both default to null, which is exactly what the clusters got until now, so
# existing deployments see no diff -- verified against a live cluster: the plan
# is byte-identical with the defaults, and setting them is what finally makes
# `zones` show up in the diff.
# ==============================================================================

variable "node_pool_zones" {
  description = <<-EOT
    Availability zones for the user node pool, e.g. ["1", "2", "3"].
    Null (default) leaves the pool unzoned. Set it deliberately on a live
    cluster: Azure treats a pool's zones as immutable, and upstream rotates the
    pool through `temporary_name_for_rotation` to honour the change.
  EOT
  type        = set(string)
  default     = null
}

# list, not set: upstream declares `agents_availability_zones` as list(string),
# while `node_pools.zones` is set(string). Matching each exactly avoids relying
# on an implicit conversion whose ordering is not guaranteed.
variable "system_pool_zones" {
  description = <<-EOT
    Availability zones for the system node pool, e.g. ["1", "2", "3"].
    Null (default) leaves the pool unzoned. Set it deliberately on a live
    cluster: Azure treats a pool's zones as immutable, and upstream rotates the
    pool through `temporary_name_for_rotation` to honour the change.
  EOT
  type        = list(string)
  default     = null
}

# ==============================================================================
# Node counts
#
# These were hardcoded (user pool min=1/max=5, system pool implicitly 2 via the
# upstream default). Hardcoding min=1 capped baseline HA: at rest the user pool
# runs a single node in a single zone, so zone spread only kicks in once
# autoscaling grows it. Exposing the counts lets a consumer set a multi-node
# floor that actually spans the zones above.
#
# Defaults equal the previous hardcoded values, so this is behaviour-preserving:
# existing consumers see no diff until they raise the floor deliberately.
# ==============================================================================

variable "user_pool_min_count" {
  description = "Minimum node count for the autoscaling user pool. Raise to >=2 (with node_pool_zones set) for a multi-zone baseline."
  type        = number
  default     = 1
}

variable "user_pool_max_count" {
  description = "Maximum node count for the autoscaling user pool."
  type        = number
  default     = 5
}

variable "system_pool_node_count" {
  description = "Fixed node count for the system pool. Defaults to 2, the upstream default this module relied on implicitly."
  type        = number
  default     = 2
}
