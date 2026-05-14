variable "nrn" {
  description = "Identifier Nullplatform Resources Name (NRN)"
  type        = string
}

variable "name" {
  description = "Display name of the dimension (e.g. 'Environment', 'Region')"
  type        = string
}

variable "order" {
  description = "Display order of the dimension"
  type        = number
  default     = 1
}

variable "values" {
  description = "List of valid values for this dimension"
  type        = list(string)
  default     = []
}
