variable "nullplatform_accounts" {
  description = "A map of nullplatform accounts to create with their configuration settings"
  type = map(object({
    name                = string
    repository_prefix   = optional(string)
    repository_provider = optional(string)
    slug                = optional(string, "poc-account")
  }))
}

