mock_provider "nullplatform" {}

run "github_provider_config" {
  command = plan

  variables {
    git_provider           = "github"
    nrn                    = "organization=myorg:account=myaccount"
    np_api_key             = "test-api-key"
    github_organization    = "myorg"
    github_installation_id = "12345"
  }

  assert {
    condition     = nullplatform_provider_config.github[0].type == "github-configuration"
    error_message = "GitHub provider config type should be 'github-configuration'"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.github[0].attributes, "myorg")
    error_message = "Attributes should contain the organization"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.github[0].attributes, "12345")
    error_message = "Attributes should contain the installation ID"
  }

  assert {
    condition     = length(nullplatform_provider_config.gitlab) == 0
    error_message = "GitLab provider should not be created for github"
  }
}

run "gitlab_provider_config" {
  command = plan

  variables {
    git_provider             = "gitlab"
    nrn                      = "organization=myorg:account=myaccount"
    np_api_key               = "test-api-key"
    gitlab_group_path        = "myorg/projects"
    gitlab_access_token      = "glpat-xxxx"
    gitlab_installation_url  = "https://gitlab.example.com"
    gitlab_repository_prefix = "myorg"
    gitlab_slug              = "myorg-projects"
    gitlab_collaborators_config = {
      collaborators = [
        {
          id   = "user1"
          role = "maintainer"
          type = "user"
        }
      ]
    }
  }

  assert {
    condition     = nullplatform_provider_config.gitlab[0].type == "gitlab-configuration"
    error_message = "GitLab provider config type should be 'gitlab-configuration'"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gitlab[0].attributes, "myorg/projects")
    error_message = "Attributes should contain the group path"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gitlab[0].attributes, "gitlab.example.com")
    error_message = "Attributes should contain the installation URL"
  }

  assert {
    condition     = length(nullplatform_provider_config.github) == 0
    error_message = "GitHub provider should not be created for gitlab"
  }
}

run "bitbucket_provider_config" {
  command = plan

  variables {
    git_provider          = "bitbucket"
    nrn                   = "organization=myorg:account=myaccount"
    np_api_key            = "test-api-key"
    bitbucket_workspace   = "myworkspace"
    bitbucket_project_key = "MYPROJ"
  }

  # The specification is slugged `bitbucket`, unlike its siblings, which carry a
  # `-configuration` suffix.
  assert {
    condition     = nullplatform_provider_config.bitbucket[0].type == "bitbucket"
    error_message = "Bitbucket provider config type should be 'bitbucket'"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.bitbucket[0].attributes, "myworkspace")
    error_message = "Attributes should contain the workspace"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.bitbucket[0].attributes, "MYPROJ")
    error_message = "Attributes should contain the project key"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.bitbucket[0].attributes, "https://bitbucket.org")
    error_message = "Attributes should default the installation URL to Bitbucket Cloud"
  }

  # The `bitbucket` specification declares no credential fields: they live in the
  # application-lifecycle-manager environment, because nullplatform nullifies secret
  # attribute values on authenticated provider reads. Sending them here would be
  # stripped server-side, so the module must not send them at all.
  assert {
    condition     = !strcontains(nullplatform_provider_config.bitbucket[0].attributes, "api_token") && !strcontains(nullplatform_provider_config.bitbucket[0].attributes, "email")
    error_message = "Attributes must not carry credential fields: the specification does not declare any"
  }

  # Removed from the specification: only Bitbucket Cloud is supported and nothing
  # reads the value.
  assert {
    condition     = !strcontains(nullplatform_provider_config.bitbucket[0].attributes, "flavor")
    error_message = "Attributes must not carry a flavor field"
  }

  assert {
    condition     = length(nullplatform_provider_config.github) == 0 && length(nullplatform_provider_config.gitlab) == 0
    error_message = "Only the Bitbucket provider should be created for bitbucket"
  }
}

# The bitbucket variables are scoped to their provider in BOTH directions: required
# when git_provider is "bitbucket", and rejected for every other provider. Without
# the second half, a gitlab install could carry leftover bitbucket values that
# silently go nowhere.
run "bitbucket_variables_rejected_for_other_providers" {
  command = plan

  variables {
    git_provider             = "gitlab"
    nrn                      = "organization=myorg:account=myaccount"
    gitlab_group_path        = "mygroup"
    gitlab_access_token      = "token"
    gitlab_installation_url  = "https://gitlab.com"
    gitlab_repository_prefix = "myorg"
    gitlab_slug              = "myorg-projects"

    bitbucket_workspace     = "myworkspace"
    bitbucket_project_key   = "MYPROJ"
    bitbucket_collaborators = [{ id = "developers", role = "read", type = "group" }]
  }

  expect_failures = [
    var.bitbucket_workspace,
    var.bitbucket_project_key,
    var.bitbucket_collaborators,
  ]
}

run "gitlab_strips_namespace_from_nrn" {
  command = plan

  variables {
    git_provider             = "gitlab"
    nrn                      = "organization=myorg:account=myaccount:namespace=mynamespace"
    np_api_key               = "test-api-key"
    gitlab_group_path        = "myorg/projects"
    gitlab_access_token      = "glpat-xxxx"
    gitlab_installation_url  = "https://gitlab.example.com"
    gitlab_repository_prefix = "myorg"
    gitlab_slug              = "myorg-projects"
    gitlab_collaborators_config = {
      collaborators = [
        {
          id   = "user1"
          role = "maintainer"
          type = "user"
        }
      ]
    }
  }

  assert {
    condition     = !strcontains(nullplatform_provider_config.gitlab[0].nrn, "namespace")
    error_message = "GitLab NRN should have namespace stripped via regex"
  }
}
