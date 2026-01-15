variable "compartment_id" {
  type        = string
  description = "The OCID of the compartment where the container repositories will be created"
}

variable "container_repositories" {
  type = map(object({
    display_name = string
    is_public    = optional(bool, false)
    is_immutable = optional(bool, false)
    readme = optional(object({
      content = string
      format  = optional(string, "TEXT_MARKDOWN")
    }), null)
    defined_tags  = optional(map(string), {})
    freeform_tags = optional(map(string), {})
  }))
  description = "Map of container repositories to create. Key is used as identifier."
  default     = {}
}

variable "defined_tags" {
  type        = map(string)
  description = "Defined tags to apply to all container repositories"
  default     = {}
}

variable "freeform_tags" {
  type        = map(string)
  description = "Freeform tags to apply to all container repositories"
  default     = {}
}
