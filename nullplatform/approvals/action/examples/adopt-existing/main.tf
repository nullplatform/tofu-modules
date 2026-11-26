################################################################################
# Example: adopt an action that already evaluates a checklist
#
# The approval action was a nullplatform_approval_action resource in this
# configuration, and the checklist it evaluates (the specification and the
# link) was created outside Terraform:
#
#   resource "nullplatform_approval_action" "deployment_create" {   # removed
#     nrn        = "organization=1:account=2:namespace=3"
#     entity     = "deployment"
#     action     = "deployment:create"
#     dimensions = { environment = "production" }
#   }
#
# The blocks below bring all three under the two modules with a plan that
# changes nothing. The steps, and what the plan must show before applying, are
# in the module's README ("Adopting an action that already evaluates a
# checklist"). The provider reads its API key from NULLPLATFORM_API_KEY.
################################################################################
terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = ">= 0.0.106"
    }
  }
}

module "payments_prod_gate" {
  source = "../../../checklist"

  # Exactly what the API returns for the version the action evaluates.
  nrn         = "organization=1:account=2:namespace=3"
  name        = "payments-prod-gate"
  description = "Production deploys: line coverage and a peer sign-off"
  definition  = jsondecode(file("${path.module}/checklists/payments-prod-gate.json"))
}

module "payments_prod_approval" {
  source = "../../"

  nrn        = "organization=1:account=2:namespace=3"
  action     = "deployment:create"
  dimensions = { environment = "production" }

  checklist = {
    specification_id = module.payments_prod_gate.current_version_id
    on_fail          = "manual" # the on_checklist_fail the action has today
  }
}

import {
  to = module.payments_prod_gate.nullplatform_checklist_specification.this
  id = "spec_0123456789abcdef" # the version the action evaluates
}

import {
  to = module.payments_prod_approval.nullplatform_approval_action_checklist_specification_association.this
  id = "123" # the action's id
}

moved {
  from = nullplatform_approval_action.deployment_create
  to   = module.payments_prod_approval.nullplatform_approval_action.this
}
