variable "cluster_name" {
  description = "Name of the cluster, used to namespace IAM resource names"
  type        = string
}

variable "application_manager_assume_role" {
  description = "ARN of the IAM role assumed by the application manager"
  type        = string
  default     = "arn:aws:iam::283477532906:role/application_manager"
}

variable "oidc_providers" {
  description = <<-EOT
    CI OIDC issuers whose jobs can assume the role, keyed by a free-form name (e.g. github, gitlab, bitbucket).
    - url: issuer URL, e.g. https://token.actions.githubusercontent.com, https://gitlab.com or https://api.bitbucket.org/2.0/workspaces/<workspace>/pipelines-config/identity/oidc
    - subjects: StringLike patterns on the sub claim, scoped to your organization, group or repositories (e.g. repo:<org>/* for GitHub, project_path:<group>/* for GitLab)
    - audiences: accepted aud claims; sts.amazonaws.com unless the CI tool fixes its own (Bitbucket uses ari:cloud:bitbucket::workspace/<uuid>)
    - create: create the IAM OIDC provider instead of looking up the existing one (an account holds one per issuer URL)
    - thumbprints: only for self-managed issuers whose certificate is not publicly trusted
  EOT
  type = map(object({
    url         = string
    subjects    = list(string)
    audiences   = optional(list(string), ["sts.amazonaws.com"])
    create      = optional(bool, false)
    thumbprints = optional(list(string), [])
  }))
  default = {}

  validation {
    condition     = alltrue([for p in values(var.oidc_providers) : startswith(p.url, "https://")])
    error_message = "every oidc_providers url must start with https://"
  }

  validation {
    # A bare or leading wildcard would let any job of the issuer (any GitHub
    # organization, any GitLab group) assume the role.
    condition     = alltrue([for p in values(var.oidc_providers) : length(p.subjects) > 0 && alltrue([for s in p.subjects : !startswith(s, "*")])])
    error_message = "every oidc_providers entry needs at least one subject pattern, and none may start with a wildcard"
  }

  validation {
    # GitHub (repo:<org>/...) and GitLab (project_path:<group>/...) name the
    # owner before the first slash: a wildcard there ("repo:*", "repo:*/x")
    # spans every organization or group of the issuer.
    condition     = alltrue([for p in values(var.oidc_providers) : alltrue([for s in p.subjects : !can(regex("^(repo|project_path):", s)) || can(regex("^(repo|project_path):[^*?/]+/", s))])])
    error_message = "repo: and project_path: subject patterns must name a literal organization or group before the first '/' (e.g. repo:my-org/*, project_path:my-group/*)"
  }

  validation {
    condition     = alltrue([for p in values(var.oidc_providers) : length(p.audiences) > 0])
    error_message = "every oidc_providers entry needs at least one audience"
  }
}
