
# ==============================================================================
# Cert-Manager Configuration
# ==============================================================================

variable "cert_manager_version" {
  description = "Version of cert-manager to install."
  type        = string
  default     = "1.18.2"
}

variable "cert_manager_namespace" {
  description = "Kubernetes namespace where cert-manager will be installed."
  type        = string
  default     = "cert-manager"
}

variable "cert_manager_config_version" {
  description = "Version of cert-manager configuration."
  type        = string
  default     = "2.22.1"
}

# ==============================================================================
# General Configuration
# ==============================================================================

variable "hosted_zone_name" {
  description = "Name of the hosted DNS zone."
  type        = string
}

variable "account_slug" {
  description = "NullPlatform account slug identifier."
  type        = string
}

# ==============================================================================
# GCP (Google Cloud Platform) Configuration
# ==============================================================================

variable "gcp_enabled" {
  description = "Enable GCP (Cloud DNS) solver in cert-manager."
  type        = bool
  default     = false
}

variable "gcp_service_account_key" {
  description = "Contents of the Service Account JSON for Cloud DNS. Required if gcp_enabled is true."
  type        = string
  sensitive   = true
  default     = null

  validation {
    condition     = !var.gcp_enabled || (var.gcp_enabled && var.gcp_service_account_key != null && var.gcp_service_account_key != "")
    error_message = "The 'gcp_service_account_key' variable is required when 'gcp_enabled' is true."
  }
}

# ==============================================================================
# Azure Configuration
# ==============================================================================

variable "azure_enabled" {
  description = "Enable Azure DNS solver in cert-manager."
  type        = bool
  default     = false
}

variable "azure_subscription_id" {
  description = "Azure Subscription ID. Required if azure_enabled is true."
  type        = string
  default     = null

  validation {
    condition     = !var.azure_enabled || (var.azure_enabled && var.azure_subscription_id != null && var.azure_subscription_id != "")
    error_message = "The 'azure_subscription_id' variable is required when 'azure_enabled' is true."
  }
}

variable "azure_resource_group_name" {
  description = "Azure Resource Group name that contains the DNS zone. Required if azure_enabled is true."
  type        = string
  default     = null

  validation {
    condition     = !var.azure_enabled || (var.azure_enabled && var.azure_resource_group_name != null && var.azure_resource_group_name != "")
    error_message = "The 'azure_resource_group_name' variable is required when 'azure_enabled' is true."
  }
}

variable "azure_client_id" {
  description = "Azure App (Client) ID for authentication. Required if azure_enabled is true."
  type        = string
  default     = null

  validation {
    condition     = !var.azure_enabled || (var.azure_enabled && var.azure_client_id != null && var.azure_client_id != "")
    error_message = "The 'azure_client_id' variable is required when 'azure_enabled' is true."
  }
}

variable "azure_secret_key" {
  description = "Key name inside the Azure Secret that holds the client secret (default 'client-secret')."
  type        = string
  default     = "client-secret"
}

variable "azure_client_secret" {
  description = "Azure App Client Secret value. Required if azure_enabled is true."
  type        = string
  sensitive   = true
  default     = null

  validation {
    condition     = !var.azure_enabled || (var.azure_enabled && var.azure_client_secret != null && var.azure_client_secret != "")
    error_message = "The 'azure_client_secret' variable is required when 'azure_enabled' is true."
  }
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID. Required if azure_enabled is true."
  type        = string
  default     = null

  validation {
    condition     = !var.azure_enabled || (var.azure_enabled && var.azure_tenant_id != null && var.azure_tenant_id != "")
    error_message = "The 'azure_tenant_id' variable is required when 'azure_enabled' is true."
  }
}

variable "azure_hosted_zone_name" {
  description = "Name of the DNS zone hosted in Azure DNS. Required if azure_enabled is true."
  type        = string
  default     = null

  validation {
    condition     = !var.azure_enabled || (var.azure_enabled && var.azure_hosted_zone_name != null && var.azure_hosted_zone_name != "")
    error_message = "The 'azure_hosted_zone_name' variable is required when 'azure_enabled' is true."
  }
}

# ==============================================================================
# Cloudflare Configuration
# ==============================================================================

variable "cloudflare_enabled" {
  description = "Enable Cloudflare DNS-01 solver in cert-manager."
  type        = bool
  default     = false
}

variable "cloudflare_secret_name" {
  description = "Kubernetes Secret name that stores the Cloudflare API Token."
  type        = string
  default     = "cloudflare-api-token-secret"
}

variable "cloudflare_token" {
  description = "Cloudflare API Token with minimum permissions: Zone:DNS:Edit + Zone:Read. Required if cloudflare_enabled is true."
  type        = string
  sensitive   = true
  default     = null

  validation {
    condition     = !var.cloudflare_enabled || (var.cloudflare_enabled && var.cloudflare_token != null && var.cloudflare_token != "")
    error_message = "The 'cloudflare_token' variable is required when 'cloudflare_enabled' is true."
  }
}