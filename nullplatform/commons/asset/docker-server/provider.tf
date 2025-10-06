terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = ">= 0.0.67"
    }
  }
}
provider "nullplatform" {

  api_key = var.np_api_key
}