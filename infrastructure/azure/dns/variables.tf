variable "resource_group" {
  type        = string
  description = "The name of the resource group"
}

variable "domain_name" {
  type        = string
  description = "The domain name to use for the DNS zone"
}

variable "subscription_id" {
  type        = string
  description = "The Azure subscription Id."
}
