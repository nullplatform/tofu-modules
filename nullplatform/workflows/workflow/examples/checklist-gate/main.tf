################################################################################
# Example: a checklist whose external item is served by a workflow
#
# The workflow listens for checklist items of one kind, and the checklist
# dispatches its external item with that kind. The kind is written once, in the
# workflow's YAML, and the checklist reads it from the module's checklist_item_kinds, so
# the checklist is published only once the workflow listens. The provider reads
# its API key from NULLPLATFORM_API_KEY.
#
# The checklist is the provider's resource so the example stands alone; with
# a checklist module the definition is the same and the kind comes from the
# same output.
################################################################################
terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = ">= 0.0.114"
    }
  }
}

module "payments_gate_workflow" {
  source = "../../"

  nrn         = "organization=1"
  key         = "payments-gate"
  name        = "Payments gate"
  description = "Serves the external items of the payments production gate"
  folder      = "/governance/checklists"

  # file(), not templatefile(): the workflow's ${{ }} expressions are not
  # Terraform's, and file() leaves them as they are.
  definition = yamldecode(file("${path.module}/workflows/payments-gate.yaml"))
}

resource "nullplatform_checklist_specification" "payments_gate" {
  nrn         = "organization=1"
  name        = "payments-prod-gate"
  description = "Production deploys: a security scan run by a workflow"

  definition = jsonencode({
    items = [
      {
        id       = "security_scan"
        type     = "external"
        behavior = "gate"
        severity = "major"
        title    = "Security scan passes"
        external = {
          # One kind per step: the trigger of this step listens for it.
          kind = module.payments_gate_workflow.checklist_item_kinds["on_item"]
        }
      },
    ]
  })
}

output "workflow_id" {
  description = "The workflow that serves the checklist's external item."
  value       = module.payments_gate_workflow.id
}

output "checklist_version_id" {
  description = "The version an approval action links to."
  value       = nullplatform_checklist_specification.payments_gate.current_version_id
}
