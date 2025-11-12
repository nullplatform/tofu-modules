###############################################################################
# EXTERNAL-DNS CONFIGURATION
###############################################################################

variable "external_dns_version" {
  type    = string
  default = "1.19.0"

}

variable "external_dns_namespace" {
  type = string
  default = "external-dns"
}
variable "domain" {
  type = string

}

variable "txt_owner_id" {
  type    = string
  default = "external_dns"

}


###############################################################################
# CLOUDFLARE CONFIGURATION
###############################################################################


variable "cloudflare_token" {
  type      = string
  sensitive = true
  default     = null
  validation {
    condition     = var.dns_provider_name != "cloudflare" || var.cloudflare_token != null
    error_message = "cloudflare_token is required when dns_provider_name is 'cloudflare'."
  }
}

###############################################################################
# DNS PROVIDER CONFIGURATION
###############################################################################

variable "dns_provider_name" {
  type        = string
  description = "The DNS provider to use with ExternalDNS "
  validation {
    condition     = contains(["cloudflare", "google"], var.dns_provider_name)
    error_message = "dns_provider_name must be either 'cloudflare' or 'google'."
  }
}

variable "extra_args" {
  type    = list(string)
}

###############################################################################
# GOOGLE CLOUD DNS CONFIGURATION
###############################################################################

variable "project_id" {
  type    = string
  default = " "

}

variable "ksa_name" {
  type    = string
  default = "external-dns"
}

variable "gsa_name" {
  type    = string
  default = "external-dns"
}

variable "cloudflare_api_token" {
  type    = string
  default = "my-secret-token"
}