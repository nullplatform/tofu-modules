variable "nullplatform_accounts" {
  description = "A map of nullplatform accounts to create with their configuration settings"
  type = map(object({
    name                = string
    repository_prefix   = optional(string, "poc-account")
    repository_provider = optional(string, "github")
    slug                = optional(string, "poc-account")
  }))
}

variable "np_api_key" {
  type        = string
  description = "The nullplatform API key (must be at the organization level)"

}