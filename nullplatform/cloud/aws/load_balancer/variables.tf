
# ========================================
# VARIABLES
# ========================================

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for internal ALB (minimum 2 in different AZs)"
  type        = list(string)
}

variable "public_subnet_ids" {
  description = "List of public subnet IDs for public ALB (minimum 2 in different AZs)"
  type        = list(string)
}

variable "vpc_cidr" {
  description = "VPC CIDR block for internal ALB security group"
  type        = string
}

variable "certificate_arn" {
  description = "ARN of the ACM certificate for HTTPS"
  type        = string
}
