
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
  type = string

}


variable "project_id" {
  type = string

}

variable "np_api_key" {
  type = string

}

variable "private_dns_zone_name" {
  type    = string
  default = ""

}
variable "public_dns_zone_name" {
  type    = string
  default = ""
}
variable "service_account_key" {
  type    = string
  default = ""

}