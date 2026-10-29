terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # nullplatform_package.requires_provider
      version = ">= 0.0.110"
    }

    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.5"
    }
    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.4"
    }
  }
}
