terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # 0.0.113 takes `slug` on the two specification resources (service_slug,
      # link_slugs); 0.0.112 dropped nullplatform_package.requires_provider.
      version = ">= 0.0.113"
    }
    http = {
      source  = "hashicorp/http"
      version = "~> 3.0"
    }
  }
}
