terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # 0.0.113 takes `slug` on the specification resources.
      version = ">= 0.0.113"
    }
  }
}
