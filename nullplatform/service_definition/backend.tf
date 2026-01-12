terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
    }
    github = {
      source = "integrations/github"
    }
    external = {
      source = "hashicorp/external"
    }
    null = {
      source = "hashicorp/null"
    }
  }
}
