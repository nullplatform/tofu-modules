variable "external_dns_version" {
  type    = string
  default = "1.19.0"

}

variable "externa_dns_namespace" {
  type = string
}
variable "domain" {
  type = string

}

variable "txt_owner_id" {
  type = string

}

variable "cloudflare_token" {
  type      = string
  sensitive = true

}

variable "dns_provider_name" {
  type        = string
  description = "dns provider"

}

variable "extra_args" {
  type    = list(string)
  default = [""]
}

variable "kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}
variable "kube_context" {
  type    = string
  default = null # o el nombre de tu context
}