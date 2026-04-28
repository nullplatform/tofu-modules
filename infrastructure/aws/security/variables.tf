variable "cluster_name" {
  type        = string
  description = "The EKS cluster name, used for naming security resources and deriving VPC."
}

variable "gateways_enabled" {
  type        = bool
  description = "Whether public gateways are enabled."
  default     = true
}

variable "gateway_internal_enabled" {
  type        = bool
  description = "Whether the internal (private) gateway is enabled."
  default     = false
}

variable "vpc_id" {
  type        = string
  description = "Override: The VPC ID. If empty, derived automatically from cluster name."
  default     = ""
}

variable "network_cidr" {
  type        = string
  description = "Override: The network CIDR block. If empty, derived automatically from VPC."
  default     = ""
}

variable "additional_network_cidrs" {
  type        = list(string)
  description = "Additional CIDR blocks to allow in security group rules (e.g., peered VPC, on-premises network)."
  default     = []
}

variable "health_check_rules_enabled" {
  type        = bool
  description = "Whether to create port 15021 (Istio health check) inbound rules on the gateway SGs. Set to false when using ALB (health checks are outbound from ALB, not inbound). Only needed for NLB/direct access patterns."
  default     = true
}

