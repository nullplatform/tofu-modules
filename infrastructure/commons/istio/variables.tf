variable "istio_base_version" {
  type    = string
  default = "1.27.1"

}

variable "istio_ingressgateway_version" {
  type    = string
  default = "1.27.1"

}

variable "istiod_version" {
  type    = string
  default = "1.27.1"

}

variable "kubeconfig_path" {
  type    = string
  default = "~/.kube/config"
}
variable "kube_context" {
  type    = string
  default = null
}