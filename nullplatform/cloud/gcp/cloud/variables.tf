variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "domain_name" {
  description = "Domain name for the configuration"
  type        = string
}

variable "project_id" {
  description = "GCP project ID where resources will be created"
  type        = string
}

variable "private_dns_zone_name" {
  description = "Name of the private DNS zone in GCP Cloud DNS"
  type        = string
  default     = ""
}

variable "public_dns_zone_name" {
  description = "Name of the public DNS zone in GCP Cloud DNS"
  type        = string
  default     = ""
}

variable "application_domain" {
  description = "Whether this is an application domain"
  type        = bool
  default     = false
}

variable "dimensions" {
  description = "Dimensions for the provider configuration"
  type        = map(any)
  default     = {}
}
