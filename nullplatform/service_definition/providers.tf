terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # nullplatform_package.requires_provider
      version = ">= 0.0.110"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}
