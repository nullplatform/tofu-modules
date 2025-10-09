variable "nullplatform_users" {
  description = "Map of Nullplatform users to create with their profile information and role assignments"
  type = map(object({
    email      = string
    first_name = string
    last_name  = string
    role_slug  = list(string)
    nrn        = string
  }))
}

variable "np_api_key" {
  description = "Nullplatform API key for authentication"
  type        = string
  sensitive   = true
}
