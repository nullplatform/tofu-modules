variable "nullplatform_accounts" {
  description = "Map of Nullplatform accounts to create with their configuration settings"
  type = map(object({
    name                = string
    repository_prefix   = optional(string, "poc-account")
    repository_provider = optional(string, "github")
    slug                = optional(string, "poc-account")
  }))
}

variable "np_api_key" {
  type        = string
  description = "The API token must be at the organization level"

}