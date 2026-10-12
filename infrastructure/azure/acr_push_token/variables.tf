###############################################################################
# REQUIRED VARIABLES
###############################################################################

variable "containerregistry_name" {
  type        = string
  description = "The name of the existing Azure Container Registry the token is created in"
}

variable "resource_group_name" {
  type        = string
  description = "The name of the resource group of the container registry"
}

###############################################################################
# OPTIONAL VARIABLES
###############################################################################

variable "token_name" {
  type        = string
  description = "The name of the ACR token. It is also the username CI logs in with"
  default     = "nullplatform-ci-push"
}

variable "password_expiry" {
  type        = string
  description = "RFC 3339 timestamp when the token password expires (e.g. 2027-01-01T00:00:00Z). Null means it never expires. Changing it regenerates the password, so the docker-server asset must be re-applied with the new value"
  default     = null

  validation {
    condition     = var.password_expiry == null || can(formatdate("YYYY", var.password_expiry))
    error_message = "password_expiry must be an RFC 3339 timestamp, e.g. 2027-01-01T00:00:00Z."
  }
}
