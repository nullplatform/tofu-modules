###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "project_id" {
  type        = string
  description = "The GCP project ID"
}

variable "domain_name" {
  type        = string
  description = "The domain name to use for the DNS zone (e.g., example.com)"
}

###############################################################################
# OPTIONAL VARIABLES - DNS CONFIGURATION
###############################################################################

variable "dns_zone_name" {
  type        = string
  description = "The name of the DNS zone resource (defaults to domain name with dashes)"
  default     = null
}

variable "visibility" {
  type        = string
  description = "Zone visibility: public or private"
  default     = "public"
}

variable "vpc_ids" {
  type        = list(string)
  description = "Vpc self-links for private DNS zone association"
  default     = []
}

###############################################################################
# OPTIONAL VARIABLES - TAGS AND METADATA
###############################################################################

variable "tags" {
  type        = map(string)
  description = "A mapping of labels to assign to the DNS zone"
  default     = {}
}
