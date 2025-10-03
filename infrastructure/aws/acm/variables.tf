variable "zone_id" {
  description = "Route53 Zone ID where certificate will be validated"
  type        = string
}

variable "domain_name" {
  type = string
}

variable "subject_alternative_names" {
  type        = list(string)
  description = "Alternative DNS to add"
  default     = []
}