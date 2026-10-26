terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = ">= 0.0.110"
    }
    external = {
      source  = "hashicorp/external"
      version = "~> 2.3.5"
    }
  }
}
