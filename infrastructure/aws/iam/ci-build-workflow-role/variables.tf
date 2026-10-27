variable "cluster_name" {
  description = "Name of the cluster, used to namespace IAM resource names"
  type        = string
}

variable "application_manager_assume_role" {
  description = "ARN of the IAM role assumed by the application manager"
  type        = string
  default     = "arn:aws:iam::283477532906:role/application_manager"
}

variable "github_organization" {
  description = "GitHub organization nullplatform creates application repositories in (the code_repository module's github_organization). GitHub Actions workflows of any repository in it can assume the role with their OIDC token, which is how `np asset push` gets AWS credentials on the runner. Null leaves the role assumable only by the application manager."
  type        = string
  default     = null

  validation {
    # A wildcard or a slash would widen the trust to repositories of other organizations.
    condition     = var.github_organization == null || can(regex("^[A-Za-z0-9-]+$", var.github_organization))
    error_message = "github_organization must be a literal GitHub organization name (letters, digits and hyphens)"
  }
}

variable "create_github_oidc_provider" {
  description = "Create the GitHub Actions OIDC provider (token.actions.githubusercontent.com). Leave false when the account already has one: an account holds a single provider per issuer URL, and the existing one is looked up."
  type        = bool
  default     = false
}
