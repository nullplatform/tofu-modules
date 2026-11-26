terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # 0.0.106 has nullplatform_checklist_specification.
      version = ">= 0.0.106"
    }
  }
}
