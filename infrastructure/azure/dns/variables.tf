###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "resource_group" {
  type        = string
  description = "The name of the resource group where the DNS zone will be created"
}

variable "domain_name" {
  type        = string
  description = "The domain name to use for the DNS zone (e.g., example.com)"
}

variable "subscription_id" {
  type        = string
  description = "The ID of the Azure subscription"
}

###############################################################################
# OPTIONAL VARIABLES - TAGS
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the DNS zone"
  default     = {}
}
