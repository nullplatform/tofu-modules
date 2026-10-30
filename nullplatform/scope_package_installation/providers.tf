terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = ">= 0.0.110"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}
