################################################################################
# Example: one approval action decided by a checklist
#
# Production deploys in one namespace evaluate a checklist kept at the account.
# Every apply that publishes a new version of the checklist re-links the action
# to it in the same apply. The provider reads its API key from
# NULLPLATFORM_API_KEY.
################################################################################
terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = ">= 0.0.106"
    }
  }
}

module "prod_deploy_gate" {
  source = "../../../checklist"

  nrn  = "organization=1:account=2"
  name = "prod-deploy-gate"

  definition = {
    items = [
      {
        id       = "coverage_gate"
        type     = "condition"
        behavior = "gate"
        severity = "major"
        title    = "Line coverage at least 80%"
        query    = { "build.metadata.coverage.lines.percent" = { "$gte" = 80 } }
      },
      {
        id              = "peer_sign_off"
        type            = "manual"
        behavior        = "gate"
        severity        = "major"
        title           = "A peer signs off the deploy"
        require_comment = true
      },
    ]
  }
}

module "payments_prod_approval" {
  source = "../../"

  nrn        = "organization=1:account=2:namespace=3" # the checklist lives in the account
  action     = "deployment:create"
  dimensions = { environment = "production" }

  checklist = {
    specification_id = module.prod_deploy_gate.current_version_id
    on_fail          = "manual" # a failed gate goes to review and the reviewers are notified
  }
}

output "payments_prod_approval_id" {
  description = "Id of the approval action."
  value       = module.payments_prod_approval.id
}
