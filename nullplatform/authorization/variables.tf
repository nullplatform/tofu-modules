variable "nrn" {
  description = "The nullplatform resource name (NRN)"
  type        = string
}

variable "destination" {
  description = "The name of the resource to use"
  type        = string
}

variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication"
}