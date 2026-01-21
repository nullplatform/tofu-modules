variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where the DNS zone will be created"
}

variable "dns_zones" {
  type = map(object({
    name          = string
    zone_type     = optional(string, "PRIMARY")
    scope         = optional(string, "GLOBAL")
    view_id       = optional(string, null)
    defined_tags  = optional(map(string), {})
    freeform_tags = optional(map(string), {})
    external_masters = optional(list(object({
      address     = string
      port        = optional(number, 53)
      tsig_key_id = optional(string, null)
    })), [])
  }))
  description = "Map of DNS zones to create. Key is used as identifier."
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags to apply to all DNS zones"
  default     = {}
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags to apply to all DNS zones"
  default     = {}
}
