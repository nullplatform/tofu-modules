terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
      # 0.0.106 has on_checklist_fail on the approval action and
      # nullplatform_approval_action_checklist_specification_association.
      version = ">= 0.0.106"
    }
  }
}
