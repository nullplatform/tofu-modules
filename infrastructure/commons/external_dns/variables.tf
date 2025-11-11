# -----------------------------------------------------------------------------
# Version of the ExternalDNS Helm chart or image to deploy.
# -----------------------------------------------------------------------------
variable "external_dns_version" {
  type        = string
  description = "Version of the ExternalDNS Helm chart or image to deploy."
  default     = "1.19.0"
}

# -----------------------------------------------------------------------------
# Kubernetes namespace where ExternalDNS will be deployed.
# -----------------------------------------------------------------------------
variable "external_dns_namespace" {
  type        = string
  description = "Kubernetes namespace where ExternalDNS will be deployed."
  default     = "external-dns"
}

# -----------------------------------------------------------------------------
# Base domain name that ExternalDNS will manage DNS records for.
# -----------------------------------------------------------------------------
variable "domain" {
  type        = string
  description = "Base domain name that ExternalDNS will manage DNS records for."
}

# -----------------------------------------------------------------------------
# Identifier used by ExternalDNS to create and manage TXT ownership records.
# -----------------------------------------------------------------------------
variable "txt_owner_id" {
  type        = string
  description = "Identifier used by ExternalDNS to create and manage TXT ownership records."
  default     = "external_dns"
}

# -----------------------------------------------------------------------------
# API token for Cloudflare used by ExternalDNS to manage DNS records.
# This variable is required only when dns_provider_name is "cloudflare".
# -----------------------------------------------------------------------------
variable "cloudflare_token" {
  type        = string
  description = "API token for Cloudflare used by ExternalDNS to manage DNS records. Required only if dns_provider_name is 'cloudflare'."
  sensitive   = true
  default     = null

  validation {
    condition = (
    var.dns_provider_name != "cloudflare" || var.cloudflare_token != null
    )
    error_message = "The 'cloudflare_token' variable must be set when 'dns_provider_name' is 'cloudflare'."
  }
}

# -----------------------------------------------------------------------------
# The DNS provider name used by ExternalDNS.
# Allowed values: cloudflare, azure, route53
# -----------------------------------------------------------------------------
variable "dns_provider_name" {
  type        = string
  description = "The DNS provider name used by ExternalDNS. Valid options are: cloudflare, azure, or route53."

  validation {
    condition     = contains(["cloudflare", "azure", "route53", "gcp"], var.dns_provider_name)
    error_message = "Invalid DNS provider name. Valid values are: 'cloudflare', 'azure', 'gcp' or 'route53'."
  }
}

# -----------------------------------------------------------------------------
# List of additional command-line arguments to pass to the ExternalDNS deployment.
# -----------------------------------------------------------------------------
variable "extra_args" {
  type        = list(string)
  description = "List of additional command-line arguments to pass to the ExternalDNS deployment."
  default     = []
}

# -----------------------------------------------------------------------------
# Name of the Kubernetes Service Account associated with ExternalDNS.
# -----------------------------------------------------------------------------
variable "ksa_name" {
  type        = string
  description = "Name of the Kubernetes Service Account associated with ExternalDNS."
  default     = "external-dns"
}

# -----------------------------------------------------------------------------
# Google Service Account email linked to the Kubernetes Service Account when using
# Workload Identity or GKE integration.
# This variable is required only when dns_provider_name is "gcp".
# -----------------------------------------------------------------------------
variable "gsa_email" {
  type        = string
  description = "Google Service Account email linked to the Kubernetes Service Account when using Workload Identity or GKE integration. Required only if dns_provider_name is 'gcp'."
  default     = null
  sensitive   = true

  validation {
    condition = (
    var.dns_provider_name != "gcp" || var.gsa_email != null
    )
    error_message = "The 'gsa_email' variable must be set when 'dns_provider_name' is 'gcp'."
  }
}
