variable "compartment_id" {
  type        = string
  description = "value"
  default     = "value"
}
variable "region" {
  type        = string
  description = "value"
  default     = "value"
}

variable "vcn_cidrs" {
  type        = list(string)
  description = "value"
  default     = ["10.0.0.0/16"]
}

variable "vcn_name" {
  type        = string
  description = "value"
  default     = "value"

}

variable "vcn_dns_label" {
  type        = string
  description = "value"
  default     = "value"
}

variable "create_internet_gateway" {
  type        = bool
  default     = true
  description = "value"

}


variable "create_nat_gateway" {
  type        = bool
  default     = true
  description = "value"
}


variable "create_service_gateway" {
  type        = bool
  default     = true
  description = "value"
}
##### subnet private

variable "subnet_private_cidr_block" {
  type        = string
  default     = ""
  description = "value"
}


variable "subnet_private_display_name" {
  type        = string
  default     = "private-subnet"
  description = "value"
}

variable "subnet_private_prohibit_public_ip_on_vnic" {
  type        = bool
  default     = true
  description = "value"
}
##### subnet public

variable "subnet_public_cidr_block" {
  type        = string
  default     = "value"
  description = "value"
}
variable "subnet_public_display_name" {
  type        = string
  default     = "value"
  description = "value"
}

