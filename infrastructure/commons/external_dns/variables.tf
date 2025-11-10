variable "external_dns_version" {
  type    = string
  default = "1.19.0"

}

variable "external_dns_namespace" {
  type = string
  default = "external-dns"
}
variable "domain" {
  type = string

}

variable "txt_owner_id" {
  type    = string
  default = "external_dns"

}

variable "cloudflare_token" {
  type      = string
  sensitive = true
  default     = null
}

variable "dns_provider_name" {
  type        = string
  description = "The dsn provider name to use with external dns"
}

variable "extra_args" {
  type    = list(string)
}

variable "project_id" {
  type    = string
  default = " "

}

variable "ksa_name" {
  type    = string
  default = "external-dns"
}

variable "gsa_name" {
  type    = string
  default = "external-dns"
}

variable "cloudflare_api_token" {
  type    = string
  default = "mi-token-magico"
}