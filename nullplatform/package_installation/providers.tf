terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # nullplatform_package_installation, data.nullplatform_package.visible_at
      # and .components; 0.0.112 dropped missing_optional_requirements, which
      # this module no longer exposes.
      version = ">= 0.0.112"
    }
  }
}
