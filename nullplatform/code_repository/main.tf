/* If the git_provider variable is set to gitlab, create this resource. */
resource "nullplatform_provider_config" "gitlab" {
  count      = local.is_gitlab ? 1 : 0
  nrn        = try(regex("(.*):namespace.*", var.nrn)[0], var.nrn)
  type       = "gitlab-configuration"
  dimensions = {}
  attributes = jsonencode({
    "setup" : {
      "group_path" : var.gitlab_group_path,
      "access_token" : var.gitlab_access_token,
      "installation_url" : var.gitlab_installation_url
    },
    "access" : var.gitlab_collaborators_config
    }
  )

}

/* If the git_provider variable has the value github, create this resource */
resource "nullplatform_provider_config" "github" {
  count      = local.is_github ? 1 : 0
  nrn        = replace(var.nrn, ":namespace=.*$", "")
  type       = "github-configuration"
  dimensions = {}
  attributes = jsonencode({
    "setup" : {
      "organization" : var.github_organization,
      "installation_id" : var.github_installation_id
    },
    }
  )
}
