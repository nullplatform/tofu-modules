terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # nullplatform_workflow and nullplatform_workflow_alias come with 0.0.114.
      version = ">= 0.0.114"
    }
  }
}
