terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
    }
    github = {
      source = "integrations/github"
    }
    gitlab = {
      source = "gitlabhq/gitlab"
    }
    external = {
      source = "hashicorp/external"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}
