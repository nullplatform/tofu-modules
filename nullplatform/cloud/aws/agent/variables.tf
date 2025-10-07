variable "nullplatform-agent-helm-version" {
  description = "Helm chart version for the Nullplatform agent"
  type        = string
  default     = "2.11.0"
}

variable "agent_repos_scope" {
  description = "Git repository URL for agent scopes configuration"
  type        = string
  default     = "https://github.com/nullplatform/scopes.git#main"
}

variable "agent_repos_extra" {
  description = "Additional repositories for the agent configuration"
  type        = list(string)
  default     = []
}

variable "cluster_name" {
  description = "Name of the EKS cluster"
  type        = string
}

variable "tags" {
  description = "Tags to apply to identifier agent"
  type        = string
}

variable "init_scripts" {
  description = "List of initialization scripts to run"
  type        = list(string)
  default     = []
}

variable "namespace" {
  description = "Kubernetes namespace to agent run"
  type        = string
  default     = "nullplatform-tools"
}

variable "nrn" {
  description = "Identifier Nullplatform Resources Name"
  type        = string
}

variable "use_tpl_files" {
  type        = bool
  default     = true
  description = "Whether to use .tpl files (true) or .json files (false) for templates"
}

################################################################################
# Scope Definition Module Variables
################################################################################

variable "action_spec_names" {
  type = list(string)
  default = [
    "create-scope",
    "delete-scope",
    "start-initial",
    "start-blue-green",
    "finalize-blue-green",
    "rollback-deployment",
    "delete-deployment",
    "switch-traffic",
    "set-desired-instance-count",
    "pause-autoscaling",
    "resume-autoscaling",
    "restart-pods",
    "kill-instances"
  ]
  description = "List of action specification template names to fetch and create"
}

variable "logs_provider" {
  type        = string
  default     = "external"
  description = "The logs provider to be used"
}

variable "metrics_provider" {
  type        = string
  default     = "externalmetrics"
  description = "The metrics provider to be used"

}

# NRN Patch Configuration
variable "np_api_key" {
  type        = string
  sensitive   = true
  description = "Nullplatform API key for authentication"
}

variable "aws_iam_openid_connect_provider_arn" {}

variable "git_provider" {
  type        = string
  default     = "github"
  description = "Git provider (e.g., github, gitlab)"
}
variable "git_user" {
  type        = string
  default     = null
  description = "Git username for authentication"
}
variable "git_password" {
  type        = string
  default     = null
  sensitive = true
  description = "Git password or token for authentication"
}
variable "git_repo" {
  type        = string
  default     = "nullplatform/scopes"
  description = "GitHub repository containing templates"
}

variable "workflow_override_path" {
  type = string
  default = null
  description = "Path to a custom workflow file to override the default one"
}

variable "workflow_override_values" {
  type = string
  default = null
  description = "Values to override in the workflow file"

}

variable "git_ref" {
  type        = string
  default     = "main"
  description = "Git reference (branch, tag, or commit)"
}

variable "git_scope_path" {
  type        = string
  default     = "k8s"
  description = "Path within the repository for the specific scope (e.g., k8s, ecs)"
}

variable "scope_name" {
  type        = string
  description = "Name of the scope type to be created"
}
variable "scope_description" {
  type        = string
  description = "Description of the scope type to be created"
}

################################################################################
# Scope Definition Module Variables
################################################################################
variable "agent_tags" {
  type        = map(string)
  description = "Agent tags"

}

variable "channel_sources" {
  type        = list(string)
  description = "List of sources for the notification channel (e.g., ['monitoring', 'alerts'])"
  default = [ "telemetry", "service" ]
}

variable "channel_type" {
  type        = string
  description = "Type of the notification channel (e.g., 'agent')"
  default     = "agent"

}

variable "agent_api_key" {
  type        = string
  description = "API key with permsissions to run commands on agents (usually ops permisions)"
  sensitive   = true
}

variable "scope_slug" {
  type        = string
  description = "The slug of the scope definition"
  default = null
}

variable "agent_command" {
  type = object({
    type = string
    data = object({
      cmdline     = string
      arguments   = optional(list(string), [])
      environment = optional(map(string), {})
    })
  })
  default = null

}

variable "scope_provider_id" {
  type        = string
  description = "The ID of the scope provider associated with the scope definition"
  default     = null

}

variable "scope_definition" {
  type = object({
    slug = string,
    nrn = string,
    workflow_override_path = string,
    workflow_override_values = string,
    scope_provider_id = string,
    specification = object({
      agent_command = object({
        type = string
        data = object({
          cmdline     = string
          arguments   = optional(list(string), [])
          environment = optional(map(string), {})
        })
      })
    })
  })
}