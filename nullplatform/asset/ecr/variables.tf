variable "nrn" {
  description = "The nullplatform resource name (NRN)"
  type        = string
}

variable "application_manager_assume_role" {
  description = "ARN of the IAM role assumed by the application manager"
  type        = string
  default     = "arn:aws:iam::283477532906:role/application_manager"
}

variable "cluster_name" {
  description = "Name of the cluster where the policy runs"
  type        = string
}
