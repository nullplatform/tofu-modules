/* If the git_provider variable is set to gitlab, create this resource. */
resource "nullplatform_provider_config" "gitlab" {
  count      = local.is_gitlab ? 1 : 0
  nrn        = try(regex("(.*):namespace.*", var.nrn)[0], var.nrn)
  type       = "gitlab-configuration"
  dimensions = var.dimensions
  attributes = jsonencode({
    "setup" : {
      "group_path" : var.gitlab_group_path,
      "access_token" : var.gitlab_access_token,
      "installation_url" : var.gitlab_installation_url
    }
    }
  )
}

/* If the git_provider variable has the value github, create this resource */
resource "nullplatform_provider_config" "github" {
  count      = local.is_github ? 1 : 0
  nrn        = replace(var.nrn, ":namespace=.*$", "")
  type       = "github-configuration"
  dimensions = var.dimensions
  attributes = jsonencode({
    "setup" : {
      "organization" : var.github_organization,
      "installation_id" : var.github_installation_id
    },
    }
  )
}

/* If the git_provider variable has the value azure, create this resource */
resource "nullplatform_provider_config" "azure" {
  count      = local.is_azure ? 1 : 0
  nrn        = replace(var.nrn, ":namespace=.*$", "")
  type       = "azure-devops-configuration"
  dimensions = var.dimensions
  attributes = jsonencode({
    "setup" : {
      "project" : var.azure_project,
      "access_token" : var.azure_access_token,
      "agent_pool" : var.azure_agent_pool
    },
    }
  )
}

/* If the git_provider variable has the value bitbucket, create this resource.

   The specification is slugged `bitbucket`, not `bitbucket-configuration` like its
   siblings, and it declares NO credential fields. The bot user's email and API
   token are environment variables on the application-lifecycle-manager
   deployment (BITBUCKET_EMAIL and BITBUCKET_API_TOKEN): nullplatform nullifies
   secret attribute values on authenticated provider reads, so a token stored here
   would come back null and never reach the workflow that needs it. */
resource "nullplatform_provider_config" "bitbucket" {
  count      = local.is_bitbucket ? 1 : 0
  nrn        = replace(var.nrn, ":namespace=.*$", "")
  type       = "bitbucket"
  dimensions = var.dimensions
  attributes = jsonencode({
    "setup" : {
      "workspace" : var.bitbucket_workspace,
      "project_key" : var.bitbucket_project_key,
      "installation_url" : var.bitbucket_installation_url
    },
    "access" : {
      "collaborators" : var.bitbucket_collaborators
    },
    }
  )
}
