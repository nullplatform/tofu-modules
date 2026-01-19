################################################################################
# Nullplatform API Key Module Variables
################################################################################

variable "name" {
  description = "Name of the API key"
  type        = string
}

variable "grants" {
  description = "List of grants for the API key"
  type = list(object({
    nrn       = string
    role_slug = string
  }))
  default = []
}

variable "tags" {
  description = "List of tags for the API key"
  type = list(object({
    key   = string
    value = string
  }))
  default = [
    {
      key   = "managed-by"
      value = "IaC"
    }
  ]
}
