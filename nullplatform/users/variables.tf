variable "nullplatform_users" {
  description = "Map of nullplatform users to create with their profile information and role assignments"
  type = map(object({
    email      = string
    first_name = string
    last_name  = string
    role_slug  = list(string)
    nrn        = string
  }))
}
