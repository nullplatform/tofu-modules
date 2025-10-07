variable "environments" {
  type        = list(string)
  description = "The list of environments"
  default     = ["development", "staging", "production"]
}
variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication"
}