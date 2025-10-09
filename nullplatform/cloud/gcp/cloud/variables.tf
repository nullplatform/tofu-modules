
variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "include_environment" {
  description = "Whether to use Environment as a default dimension"
  type        = bool
  default     = true
}

variable "domain_name" {
  description = "Domain name for the configuration"
  type        = string
}




variable "dimensions" {
  description = "Map of dimension values to configure Nullplatform"
  type        = map(string)
  default     = {}
}


variable "environments" {
  type        = list(string)
  description = "The list of environments"
  default     = ["development", "staging", "production"]
}

variable "location" {
  description = "GCP location/region where resources will be deployed"
  type        = string
}

variable "project_id" {
  description = "GCP project ID where resources will be created"
  type        = string
}

variable "np_api_key" {
  description = "Nullplatform API key for authentication"
  type        = string
  sensitive   = true
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

variable "service_account_key" {
  description = "GCP service account key in JSON format for authentication"
  type        = string
  sensitive   = true
  default     = ""
}
