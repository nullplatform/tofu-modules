variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the DNS zone (without trailing dot, e.g. example.com)"
}

variable "zone_name" {
  type        = string
  description = "The name of the DNS zone resource. Defaults to domain_name with dots replaced by dashes."
  default     = null
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

variable "dnssec_enabled" {
  type        = bool
  description = "Enable DNSSEC for the zone. Only applies to public zones; signing is inert until the DS record is published at the domain registrar."
  default     = true
}

variable "tags" {
  type        = map(string)
  description = "A mapping of labels to assign to the DNS managed zone"
  default     = {}
}
