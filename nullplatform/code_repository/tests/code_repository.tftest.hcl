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
