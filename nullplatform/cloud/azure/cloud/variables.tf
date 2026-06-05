variable "nrn" {
  type        = string
  description = "The NRN of your nullplatform account"
}

variable "client_id" {
  type        = string
  description = "Azure Service Principal client ID"
  sensitive   = true
}

variable "client_secret" {
  type        = string
  description = "Azure Service Principal client secret"
  sensitive   = true
}

variable "subscription_id" {
  type        = string
  description = "Azure subscription ID"
}

variable "tenant_id" {
  type        = string
  description = "Azure Active Directory tenant ID"
}

variable "domain_name" {
  description = "The domain name to be used"
  type        = string
  default     = ""
}

variable "azure_resource_group_name" {
  type        = string
  description = "Your Azure resource group name"
}

variable "private_dns_resource_group_name" {
  type        = string
  description = "Azure resource group name for the DNS private"
}

variable "application_domain" {
  type        = bool
  description = "Apply application domain or not"
  default     = false
}


variable "dimensions" {
  type        = map(any)
  description = "Define dimensions. For more information, see https://docs.nullplatform.com/docs/dimensions"
  default     = {}
}

variable "private_domain_name" {
  description = "The private domain name to be used"
  type        = string
  default     = ""
}
