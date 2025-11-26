###############################################################################
# CERT-MANAGER CONFIGURATION
###############################################################################

variable "cert_manager_version" {
  type    = string
  default = "1.18.2"
}

variable "cert_manager_namespace" {
  type    = string
  default = "cert-manager"
}

variable "cert_manager_config_version" {
  type    = string
  default = "2.26.0"
}

variable "hosted_zone_name" {
  description = "The hosted zone name (if applicable)."
  type        = string
  default     = ""
}

variable "account_slug" {
  description = "The nullplatform account slug."
  type        = string
  default     = ""
}

###############################################################################
# GCP CONFIGURATION
###############################################################################

variable "gcp_enabled" {
  description = "Whether to enable the GCP (Cloud DNS) solver in cert-manager."
  type        = bool
  default     = false
}

variable "gcp_service_account_key" {
  description = "The contents of the service account JSON for Cloud DNS (use file() if reading from disk)."
  type        = string
  sensitive   = true
  default     = ""
}

###############################################################################
# AZURE CONFIGURATION
###############################################################################

variable "azure_enabled" {
  description = "Whether to enable the Azure DNS solver in cert-manager."
  type        = bool
  default     = false
}

variable "azure_subscription_id" {
  description = "The Azure subscription ID."
  type        = string
  default     = ""
}

variable "azure_resource_group_name" {
  description = "The name of the Azure resource group that contains the DNS zone."
  type        = string
  default     = ""
}

variable "azure_client_id" {
  description = "The Azure application (client) ID for authentication."
  type        = string
  default     = ""
}

variable "azure_secret_key" {
  description = "The key name inside the Azure secret that holds the client secret (default: 'client-secret')."
  type        = string
  default     = "client-secret"
}

variable "azure_client_secret" {
  description = "The Azure application client secret value."
  type        = string
  sensitive   = true
  default     = ""
}

variable "azure_tenant_id" {
  description = "The Azure tenant ID."
  type        = string
  default     = ""
}

variable "azure_hosted_zone_name" {
  description = "The hosted zone name in Azure DNS."
  type        = string
  default     = ""
}

###############################################################################
# CLOUDFLARE CONFIGURATION
###############################################################################

variable "cloudflare_enabled" {
  description = "Whether to enable the Cloudflare DNS-01 solver in cert-manager."
  type        = bool
  default     = false
}

variable "cloudflare_secret_name" {
  description = "The name of the Kubernetes secret that stores the Cloudflare API token."
  type        = string
  default     = "cloudflare-api-token-secret"
}

variable "cloudflare_token" {
  description = "The Cloudflare API token (minimum permissions: Zone:DNS:Edit and Zone:Read)."
  type        = string
  sensitive   = true
  default     = ""
  validation {
    condition     = !var.cloudflare_enabled || length(var.cloudflare_token) > 0
    error_message = "When cloudflare_enabled is true, cloudflare_token must not be empty."
  }
}
