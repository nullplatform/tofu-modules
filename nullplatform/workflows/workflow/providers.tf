terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # nullplatform_workflow and nullplatform_workflow_alias come with the
      # provider release after 0.0.113.
      version = ">= 0.0.114"
    }
  }
}
