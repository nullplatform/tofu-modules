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

variable "dimensions" {
  description = "Dimensions to segment the nullplatform provider config (e.g. by region, environment)"
  type        = map(string)
  default     = {}
}
