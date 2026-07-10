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

variable "load_balancer" {
  description = "Load balancer wiring published under the networking provider's load_balancer.{public,private} so scope workflows (e.g. the Lambda ALB) can resolve listener/target details. Each side is free-form (e.g. { arn = ..., listener_arn = ... }); defaults to empty objects, preserving the previous behaviour."
  type = object({
    public  = optional(any, {})
    private = optional(any, {})
  })
  default = {}
}
