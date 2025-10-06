variable "nrn" {
  type        = string
  description = "The null platform nrn"
}

variable "login_server" {
  description = "Docker Login server name"
  type        = string
}

variable "path" {
  description = "Path to the registry created"
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
  type = string

}