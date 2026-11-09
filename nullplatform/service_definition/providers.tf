terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # 0.0.112 dropped nullplatform_package.requires_provider; this module
      # no longer declares it, so it needs that provider or newer.
      version = ">= 0.0.112"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}
