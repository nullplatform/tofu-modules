variable "aws_iam_openid_connect_provider_arn" {
  description = "ARN of the AWS IAM OIDC provider for EKS service account authentication"
  type        = string
}

variable "agent_namespace" {
  description = "Namespace where the agent runs"
  type        = string
}

variable "cluster_name" {
  description = "Name of the cluster where the policy runs"
  type        = string
}

variable "additional_policies" {
  description = "Additional policy ARNs to attach to the agent role"
  type        = map(string)
  default     = {}
}

variable "assume_role_arns" {
  description = "List of IAM role ARNs the agent is allowed to assume via sts:AssumeRole"
  type        = list(string)
  default     = []

  validation {
    condition     = alltrue([for arn in var.assume_role_arns : can(regex("^arn:aws:iam::[0-9]{12}:role/.+", arn))])
    error_message = "Each ARN must match arn:aws:iam::<account-id>:role/<role-name>"
  }
}

variable "service_account_name" {
  description = "Kubernetes service account name trusted by the IRSA role"
  type        = string
  default     = "nullplatform-agent"
}

variable "role_name" {
  description = "Override for the IAM role name. Defaults to nullplatform-{cluster_name}-agent-role"
  type        = string
  default     = ""
}

variable "permissions_roles" {
  description = "Additional permissions roles created by this module and assumable by the agent role. Map key is a logical name; name overrides the role name (defaults to nullplatform-{cluster_name}-{key}); policy_arns are the policy ARNs attached to the role."
  type = map(object({
    name        = optional(string)
    policy_arns = optional(list(string), [])
  }))
  default = {}

  validation {
    condition     = alltrue([for cfg in values(var.permissions_roles) : alltrue([for arn in cfg.policy_arns : can(regex("^arn:aws:iam::(aws|[0-9]{12}):policy/.+", arn))])])
    error_message = "Each policy_arn must match arn:aws:iam::<account-id|aws>:policy/<policy-name>"
  }
}

variable "policies_name_prefix" {
  description = "Override for IAM policy name prefix. Defaults to nullplatform_{cluster_name}"
  type        = string
  default     = ""
}
