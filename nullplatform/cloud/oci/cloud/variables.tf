variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "dimensions" {
  description = "Dimensions for the provider configuration"
  type        = map(any)
  default     = {}
}

variable "account_id" {
  description = "OCI tenancy/account OCID"
  type        = string
}

variable "account_name" {
  description = "OCI account/tenancy name"
  type        = string
}

variable "account_region" {
  description = "OCI region where resources will be deployed"
  type        = string
}

variable "compartment_id" {
  description = "OCI compartment OCID where resources will be created"
  type        = string
}

variable "compartment_name" {
  description = "OCI compartment name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the configuration"
  type        = string
}

variable "application_domain" {
  description = "Whether to apply application domain"
  type        = bool
  default     = false
}

variable "private_domain_name" {
  description = "Private domain name"
  type        = string
  default     = ""
}
