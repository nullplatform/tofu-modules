variable "subscription_id" {
  type = string
}
variable "tags" {

}
variable "workspace" {

}
variable "resource_group_name" {

}
variable "location" {

}
variable "cluster_name" {

}
variable "kubernetes_version" {

}

variable "authorized_ip_ranges" {

}
variable "private_cluster_enabled" {

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
variable "service_dns_ip" {

}
variable "system_pool_vm_size" {
  type    = string
  default = "Standard_D4s_v5"

}
