terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = "~> 0.0.63"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 3.0"
    }
  }
}

provider "nullplatform" {
  api_key = var.np_api_key
}