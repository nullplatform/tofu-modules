variable "nrn" {
  description = "nullplatform Resource Name where the identity & access control provider configuration applies"
  type        = string
}

variable "type" {
  description = "Slug of the nullplatform provider specification to configure (e.g. aws-iam-configuration). Set this when adding support for a new cloud."
  type        = string
  default     = "aws-iam-configuration"
}

variable "attributes" {
  description = "Provider-specific configuration, matching the schema of the selected provider type. Encoded to JSON for the provider config. For aws-iam-configuration: { iam_role_arns = { arns = [{ selector, arn }] } }."
  type        = any
}

variable "dimensions" {
  description = "Dimensions used to scope this provider configuration (e.g., environment, region)"
  type        = map(string)
  default     = {}
}
