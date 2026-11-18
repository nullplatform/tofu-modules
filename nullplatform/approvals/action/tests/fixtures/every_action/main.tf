# One instance of the module per action, so a test can read the entity each one
# derives.
terraform {
  required_providers {
    nullplatform = {
      source = "nullplatform/nullplatform"
    }
  }
}

variable "actions" {
  type = list(string)
}

module "action" {
  source   = "../../.."
  for_each = toset(var.actions)

  nrn    = "organization=1:account=2"
  action = each.value

  checklist = {
    specification_id = "spec_0123456789abcdef"
    on_fail          = "deny"
  }
}

output "entities" {
  value = { for action, approval in module.action : action => approval.entity }
}
