################################################################################
# Example: a production deploy gate
#
# Two conditions on the build (line coverage and critical vulnerabilities) and
# a sign-off by a peer, who cannot be the person who requested the deploy. The
# provider reads its API key from NULLPLATFORM_API_KEY.
#
# Link it to an approval action with ../../../action.
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
  source = "../../"

  nrn         = "organization=1:account=2"
  name        = "prod-deploy-gate"
  description = "Production deploys: line coverage, no critical vulnerabilities and a peer sign-off"

  definition = {
    execution_trigger = "explicit" # once approved, someone starts the deploy
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
        id       = "no_critical_vulnerabilities"
        type     = "condition"
        behavior = "gate"
        severity = "critical"
        title    = "No critical vulnerabilities"
        query    = { "build.metadata.security.critical" = { "$eq" = 0 } }
      },
      {
        id              = "peer_sign_off"
        type            = "manual"
        behavior        = "gate"
        severity        = "major"
        title           = "A peer signs off the deploy"
        require_comment = true
        validations = [
          {
            id      = "four_eyes"
            message = "Someone other than the requester must sign off."
            rule    = { "actor.user_id" = { "$ne" = "$approval.requested_by" } }
          },
          {
            id      = "approver_role"
            message = "Only secops or admin can sign off."
            rule    = { "actor.effective_roles" = { "$in" = ["secops", "admin"] } }
          },
        ]
      },
    ]
  }
}

output "prod_deploy_gate_version_id" {
  description = "The version an approval action links to."
  value       = module.prod_deploy_gate.current_version_id
}
