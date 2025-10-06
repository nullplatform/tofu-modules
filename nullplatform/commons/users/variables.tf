variable "nullplatform_users" {
  type = map(object({
    email      = string
    first_name = string
    last_name  = string
    role_slug  = list(string)
    nrn        = string
  }))
}

variable "np_api_key" {
}