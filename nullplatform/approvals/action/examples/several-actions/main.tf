################################################################################
# Example: several actions and environments on one checklist
#
# Creating and changing scopes in development and staging, four approval
# actions, all evaluate the same checklist version: setproduct builds one
# for_each key per action and environment. The module's README ("Several
# actions and environments") says what renaming a key does. The provider reads
# its API key from NULLPLATFORM_API_KEY.
################################################################################
terraform {
  required_providers {
    nullplatform = {
      source  = "nullplatform/nullplatform"
      version = ">= 0.0.106"
    }
  }
}

module "nonprod_sizing" {
  source = "../../../checklist"

  nrn         = "organization=1:account=2"
  name        = "nonprod-scope-sizing"
  description = "Non-production scopes start small"

  definition = {
    execution_trigger = "any_approval" # once approved, the scope change runs on its own
    items = [
      {
        id       = "small_minimum"
        type     = "condition"
        behavior = "gate"
        severity = "major"
        title    = "At most 2 instances at minimum"
        query    = { "scope.capabilities.auto_scaling.instances.min_amount" = { "$lte" = 2 } }
      },
    ]
  }
}

locals {
  nonprod_sizing = {
    for pair in setproduct(["scope:create", "scope:write"], ["development", "staging"]) :
    "${pair[0]}/${pair[1]}" => { action = pair[0], environment = pair[1] }
  }
}

module "nonprod_sizing_approval" {
  source   = "../../"
  for_each = local.nonprod_sizing

  nrn        = "organization=1:account=2"
  action     = each.value.action
  dimensions = { environment = each.value.environment }

  checklist = {
    specification_id = module.nonprod_sizing.current_version_id
    on_fail          = "deny" # a scope change over the size is rejected
  }
}

output "nonprod_sizing_approval_ids" {
  description = "Id of each approval action, by key."
  value       = { for key, approval in module.nonprod_sizing_approval : key => approval.id }
}
