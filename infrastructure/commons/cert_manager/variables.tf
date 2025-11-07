
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
  default = "2.20.1"

}

variable "hosted_zone_name" {
  description = "Hosted zone name (if applicable)."
  type        = string
  default     = ""
}

variable "account_slug" {
  description = "NullPlatform account slug."
  type        = string
  default     = ""
}

# --- GCP ---
variable "gcp_enabled" {
  description = "Enable GCP (Cloud DNS) solver in cert-manager."
  type        = bool
  default     = false
}

variable "gcp_service_account_key" {
  description = "Contents of the Service Account JSON for Cloud DNS (use file() if reading from disk)."
  type        = string
  sensitive   = true
  default     = ""
}

# --- Azure ---
variable "azure_enabled" {
  description = "Enable Azure DNS solver in cert-manager."
  type        = bool
  default     = false
}

variable "azure_subscription_id" {
  description = "Azure Subscription ID."
  type        = string
  default     = ""
}

variable "azure_resource_group_name" {
  description = "Azure Resource Group that contains the DNS zone."
  type        = string
  default     = ""
}

variable "azure_client_id" {
  description = "Azure App (Client) ID for authentication."
  type        = string
  default     = ""
}

variable "azure_secret_key" {
  description = "Key name inside the Azure Secret that holds the client secret (default 'client-secret')."
  type        = string
  default     = "client-secret"
}

variable "azure_client_secret" {
  description = "Azure App Client Secret (value)."
  type        = string
  sensitive   = true
  default     = ""
}

variable "azure_tenant_id" {
  description = "Azure Tenant ID."
  type        = string
  default     = ""
}

variable "azure_hosted_zone_name" {
  description = "Hosted zone name in Azure DNS."
  type        = string
  default     = ""
}

# --- Cloudflare ---
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
  description = "Cloudflare API Token (minimum permissions: Zone:DNS:Edit + Zone:Read)."
  type        = string
  sensitive   = true
  default     = ""
  validation {
    condition     = !var.cloudflare_enabled || length(var.cloudflare_token) > 0
    error_message = "When cloudflare_enabled is true, cloudflare_api_token must not be empty."
  }
}



