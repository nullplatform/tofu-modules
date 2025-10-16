variable "external_dns_version" {
  type    = string
  default = "1.19.0"

}

variable "external_dns_namespace" {
  type = string
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
  default   = " "

}

variable "dns_provider_name" {
  type        = string
  description = "dns provider"

}

variable "extra_args" {
  type    = list(string)
  default = [""]
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
variable "zone_name" {
  type    = string
  default = " "

}