variable "environments" {
  type        = list(string)
  description = "The list of environments"
  default     = ["development", "staging", "production"]
}
variable "nrn" {
  description = "Identifier Nullplatform Resources Name (NRN)"
  type        = string
}
