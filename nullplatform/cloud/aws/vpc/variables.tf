variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "vpc_id" {
  description = "The ID of the VPC"
  type        = string
}

variable "vpc_subnets" {
  description = "List of subnet IDs associated with the VPC"
  type        = list(string)
}

variable "vpc_security_groups" {
  description = "List of security group IDs associated with the VPC"
  type        = list(string)
}

variable "dimensions" {
  description = "Map of dimension values to configure nullplatform"
  type        = map(string)
  default     = {}
}
