terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # nullplatform_package_installation, data.nullplatform_package.visible_at
      # and .components.
      version = ">= 0.0.110"
    }
  }
}
