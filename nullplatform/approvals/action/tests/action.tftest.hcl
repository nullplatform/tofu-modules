mock_provider "nullplatform" {
  # The provider refuses to link anything but a version id (spec_...), and the
  # mock would otherwise make one up.
  mock_resource "nullplatform_checklist_specification" {
    defaults = {
      current_version_id = "spec_0123456789abcdef"
    }
  }
}

# Production deploys in a namespace, decided by a checklist version.
variables {
  nrn    = "organization=1:account=2:namespace=3"
  action = "deployment:create"

  checklist = {
    specification_id = "spec_0123456789abcdef"
    on_fail          = "manual"
  }
}

run "every_documented_action_derives_its_entity" {
  command = plan

  module {
    source = "./tests/fixtures/every_action"
  }

  variables {
    actions = [
      "deployment:create",
      "scope:create",
      "scope:recreate",
      "scope:write",
      "scope:delete",
      "scope:stop",
      "service:action:create",
      "parameter:read-secrets",
      "action_item:resolve",
      "action_item:defer",
      "action_item:reject",
    ]
  }

  assert {
    condition = output.entities == {
      "deployment:create"      = "deployment"
      "scope:create"           = "scope"
      "scope:recreate"         = "scope"
      "scope:write"            = "scope"
      "scope:delete"           = "scope"
      "scope:stop"             = "scope"
      "service:action:create"  = "service:action"
      "parameter:read-secrets" = "parameter"
      "action_item:resolve"    = "action_item"
      "action_item:defer"      = "action_item"
      "action_item:reject"     = "action_item"
    }
    error_message = "The entity must be everything before the last colon of the action"
  }
}

run "the_action_is_created_at_its_nrn_with_its_entity" {
  command = plan

  assert {
    condition     = nullplatform_approval_action.this.nrn == "organization=1:account=2:namespace=3"
    error_message = "The action must be created at the nrn given"
  }

  assert {
    condition     = nullplatform_approval_action.this.action == "deployment:create"
    error_message = "The action must reach the resource as given"
  }

  assert {
    condition     = nullplatform_approval_action.this.entity == "deployment"
    error_message = "The entity must be derived from the action"
  }

  assert {
    condition     = output.entity == "deployment" && output.action == "deployment:create"
    error_message = "The outputs must carry the entity and the action"
  }
}

run "dimensions_default_to_an_empty_map" {
  command = plan

  assert {
    condition     = length(nullplatform_approval_action.this.dimensions) == 0
    error_message = "Without dimensions the action must have none"
  }

  assert {
    condition     = length(output.dimensions) == 0
    error_message = "The dimensions output must be empty without dimensions"
  }
}

run "dimensions_reach_the_action_as_given" {
  command = plan

  variables {
    dimensions = {
      environment = "production"
      country     = "us"
    }
  }

  assert {
    condition     = nullplatform_approval_action.this.dimensions == tomap({ environment = "production", country = "us" })
    error_message = "The dimensions must reach the action as given"
  }

  assert {
    condition     = output.dimensions == tomap({ environment = "production", country = "us" })
    error_message = "The dimensions output must be the dimensions given"
  }
}

run "on_fail_becomes_the_actions_on_checklist_fail" {
  command = plan

  assert {
    condition     = nullplatform_approval_action.this.on_checklist_fail == "manual"
    error_message = "checklist.on_fail must be the action's on_checklist_fail"
  }
}

run "pending_is_accepted" {
  command = plan

  variables {
    checklist = {
      specification_id = "spec_0123456789abcdef"
      on_fail          = "pending"
    }
  }

  assert {
    condition     = nullplatform_approval_action.this.on_checklist_fail == "pending"
    error_message = "pending must reach the action"
  }
}

run "deny_is_accepted" {
  command = plan

  variables {
    checklist = {
      specification_id = "spec_0123456789abcdef"
      on_fail          = "deny"
    }
  }

  assert {
    condition     = nullplatform_approval_action.this.on_checklist_fail == "deny"
    error_message = "deny must reach the action"
  }
}

run "the_module_sets_no_policies" {
  command = plan

  assert {
    condition     = nullplatform_approval_action.this.policies == null
    error_message = "The module must not associate policies with the action"
  }
}

run "the_link_takes_the_specification_version_given" {
  command = plan

  assert {
    condition     = nullplatform_approval_action_checklist_specification_association.this.checklist_specification_id == "spec_0123456789abcdef"
    error_message = "The link must point at checklist.specification_id"
  }
}

run "the_link_is_for_the_action_the_module_creates" {
  command = apply

  assert {
    condition     = nullplatform_approval_action_checklist_specification_association.this.approval_action_id == nullplatform_approval_action.this.id
    error_message = "The link must be for the module's action"
  }

  assert {
    condition     = output.id == nullplatform_approval_action.this.id
    error_message = "The id output must be the action's id"
  }
}

run "an_action_without_a_verb_is_refused" {
  command = plan

  variables {
    action = "deployment"
  }

  expect_failures = [var.action]
}

run "an_action_without_an_entity_is_refused" {
  command = plan

  variables {
    action = ":create"
  }

  expect_failures = [var.action]
}

run "an_action_in_capitals_is_refused" {
  command = plan

  variables {
    action = "Deployment:Create"
  }

  expect_failures = [var.action]
}

run "an_on_fail_outside_deny_manual_pending_is_refused" {
  command = plan

  variables {
    checklist = {
      specification_id = "spec_0123456789abcdef"
      on_fail          = "approve"
    }
  }

  expect_failures = [var.checklist]
}

# The object type already makes on_fail required; a null would reach the API
# as no value at all.
run "a_null_on_fail_is_refused" {
  command = plan

  variables {
    checklist = {
      specification_id = "spec_0123456789abcdef"
      on_fail          = null
    }
  }

  expect_failures = [var.checklist]
}

# As on the apply that publishes a new version. The only run where the version
# is unknown at plan: the mock gives the specification's one a value.
run "the_link_plans_with_a_version_not_known_until_apply" {
  command = plan

  module {
    source = "./tests/fixtures/unknown_version"
  }
}

run "the_single_action_example_plans" {
  command = plan

  module {
    source = "./examples/single-action"
  }
}

run "the_several_actions_example_plans_one_action_per_key" {
  command = plan

  module {
    source = "./examples/several-actions"
  }

  assert {
    condition = toset(keys(output.nonprod_sizing_approval_ids)) == toset([
      "scope:create/development",
      "scope:create/staging",
      "scope:write/development",
      "scope:write/staging",
    ])
    error_message = "setproduct must give one action per action and environment, keyed <action>/<environment>"
  }
}
