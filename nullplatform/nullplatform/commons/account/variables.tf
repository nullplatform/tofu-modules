variable "nullplatform_accounts" {
  type = map(object({
    name                = string
    repository_prefix   = optional(string, "poc-account")
    repository_provider = optional(string, "github")
    slug                = optional(string, "poc-account")
  }))
}

variable "np_api_key" {

}