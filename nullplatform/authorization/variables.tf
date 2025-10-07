variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "destination" {
  description = "Name of resource to use"
  type        = string
}

variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication"
}