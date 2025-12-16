variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "zone_name" {
  type        = string
  description = "The name of the DNS zone resource"
}

variable "domain_name" {
  type        = string
  description = "The domain name (without trailing dot)"
}

variable "visibility" {
  type        = string
  description = "Zone visibility: public or private"
  default     = "public"
}

variable "private_zone_networks" {
  type        = list(string)
  description = "VPC network self-links for private zones"
  default     = []
}
