variable "name" {
  description = "Unique identifier for policy naming. Must be unique per AWS account (IAM policy names are account-global). Example: \"prod-us-east-1\"."
  type        = string
}
