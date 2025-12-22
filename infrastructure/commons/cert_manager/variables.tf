###############################################################################
# CERT-MANAGER PROVIDER
###############################################################################
variable "cloud_provider" {
  description = "El proveedor de nube a utilizar: gcp, azure, o cloudflare"
  type        = string
  validation {
    condition     = contains(["gcp", "azure", "cloudflare"], var.cloud_provider)
    error_message = "El valor debe ser uno de: gcp, azure, cloudflare."
  }
}

variable "gcp_sa_email" {
  type    = string
  default = ""
}

variable "project_id" {
  description = "The GCP project ID for cert-manager DNS01 solver"
  type        = string
  default     = ""
}

variable "aws_sa_arn" {
  type    = string
  default = ""
}

variable "azure_client_id" {
  type    = string
  default = ""
}

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
# AZURE CONFIGURATION
###############################################################################


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
    condition     = var.cloud_provider != "cloudflare" || length(var.cloudflare_token) > 0
    error_message = "When cloud_provider is 'cloudflare', cloudflare_token must not be empty."
  }
}
