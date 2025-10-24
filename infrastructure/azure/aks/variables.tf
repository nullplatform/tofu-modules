variable "subscription_id" {
  type = string
}
variable "tags" {
  type    = map(string)
  default = {}

}

variable "resource_group_name" {
  type = string

}
variable "location" {
  type = string


}
variable "cluster_name" {

}
variable "kubernetes_version" {
  type    = string
  default = "1.32.7"

}


variable "authorized_ip_ranges" {
  type    = set(string)
  default = null

}
variable "private_cluster_enabled" {
  type    = bool
  default = false

}
variable "user_pool_vm_size" {
  type    = string
  default = "Standard_D4s_v5"

}

variable "vnet_subnet_id" {

}
variable "environment" {
  type    = string
  default = "nullplatform"

}

variable "system_pool_vm_size" {
  type    = string
  default = "Standard_D4s_v5"

}

variable "cluster_log_analytics_workspace_name" {
  type    = string
  default = null

}
variable "prefix" {
  type    = string
  default = "test"

}