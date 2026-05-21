variable "node_resource_group" {
  description = "The resource group where AKS creates its managed node resources (including the kubenet route table)"
  type        = string
}

variable "subnet_id" {
  description = "The resource ID of the AKS node subnet to keep the route table attached to"
  type        = string
}
