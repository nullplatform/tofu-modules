variable "name" {
  type        = string
  description = "Name prefix for resource tags."
  default     = ""
}

variable "cluster_security_group_id" {
  type        = string
  description = "The EKS cluster primary security group ID. Ingress rules allowing traffic from the gateway SGs are created on this SG."
}

variable "public_gateway_security_group_id" {
  type        = string
  description = "Security group ID of the public Istio gateway (from the security module)."
  default     = ""
}

variable "private_gateway_security_group_id" {
  type        = string
  description = "Security group ID of the private Istio gateway (from the security module)."
  default     = ""
}

variable "gateways_enabled" {
  type        = bool
  description = "Whether to create ingress rules for the public gateway."
  default     = true
}

variable "gateway_internal_enabled" {
  type        = bool
  description = "Whether to create ingress rules for the private gateway."
  default     = false
}

variable "gateway_port" {
  type        = number
  description = "Port used by Istio gateway pods for application traffic (e.g. 80, 8080, 8443)."
  default     = 80
}
