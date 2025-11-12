variable "nrn" {
  type        = string
  description = "The nullplatform resource name (NRN)"
}

variable "login_server" {
  description = "Docker login server name"
  type        = string
}

variable "path" {
  description = "Path to the created registry"
  type        = string
}

variable "username" {
  description = "Docker username"
  type        = string
  default     = "_json_key_base64"
}

variable "password" {
  description = "Docker password"
  type        = string
  sensitive   = false
}

variable "np_api_key" {
  description = "Nullplatform API key for authentication"
  type        = string
  sensitive   = true
}
