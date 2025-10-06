variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication"
}

variable "application_manager_assume_role" {
  description = "ARN of the IAM role for application manager"
  type        = string
  default     = "arn:aws:iam::283477532906:role/application_manager"
}