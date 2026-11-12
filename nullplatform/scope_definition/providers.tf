terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # 0.0.113 takes `slug` on nullplatform_service_specification
      # (service_spec_slug); 0.0.112 dropped nullplatform_package.requires_provider.
      version = ">= 0.0.113"
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
