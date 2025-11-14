variable "np_api_key" {
  type        = string
  description = "Your nullplatform API key (developer, member, ops, and secops permissions)"
}

variable "azure_subscription_id" {
  type        = string
  description = "Your Azure subscription ID"
}

variable "azure_tenant_id" {
  type        = string
  description = "Your Azure tenant ID"
}

variable "nrn" {
  type        = string
  description = "The NRN of your nullplatform account"
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
  default = false
}


variable "dimensions" {
  type        = map(any)
  description = "Define dimensions. For more information, see https://docs.nullplatform.com/docs/dimensions"
  default     = {}
}

variable "private_domain_name" {}
