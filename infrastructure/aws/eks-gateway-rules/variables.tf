variable "cluster_name" {
  type        = string
  description = "EKS cluster name, used for resource naming tags."
  default     = ""
}

variable "cluster_security_group_id" {
  type        = string
  description = "The EKS cluster primary security group ID. Ingress rules allowing traffic from the gateway SGs are created on this SG."
}

variable "public_gateway_security_group_id" {
  type        = string
  description = "Security group ID of the public Istio gateway (from the security module). Leave empty to skip public gateway rules."
  default     = ""
}

variable "private_gateway_security_group_id" {
  type        = string
  description = "Security group ID of the private Istio gateway (from the security module). Leave empty to skip private gateway rules."
  default     = ""
}

variable "gateway_port" {
  type        = number
  description = "Port used by Istio gateway pods for application traffic (e.g. 80, 8080, 8443)."
  default     = 80
}
