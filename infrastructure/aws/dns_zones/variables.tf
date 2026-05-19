variable "vpc_id" {
  type        = string
  description = "The ID of the VPC"
}
variable "domain_name" {
  type        = string
  description = "The domain name to be managed"
}

variable "enable_public_zone" {
  type        = bool
  description = "Whether to create the public dns zone"
}

variable "enable_private_zone" {
  type        = bool
  description = "Whether to create the private dns zone"
}