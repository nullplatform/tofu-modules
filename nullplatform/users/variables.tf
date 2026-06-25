variable "nullplatform_users" {
  description = "Map of nullplatform users to create with their profile information and role assignments"
  type = map(object({
    email      = string
    first_name = string
    last_name  = string
    role_slug  = list(string)
    nrn        = string
  }))

  validation {
    condition     = alltrue([for u in values(var.nullplatform_users) : can(regex("^[^@[:space:]]+@[^@[:space:]]+\\.[^@[:space:]]+$", u.email))])
    error_message = "Each user's email must be a valid email address (e.g. name@example.com)."
  }

  validation {
    condition     = alltrue([for u in values(var.nullplatform_users) : length(u.role_slug) > 0])
    error_message = "Each user must have at least one role_slug."
  }
}
