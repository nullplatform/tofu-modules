terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = ">= 0.0.102"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}
