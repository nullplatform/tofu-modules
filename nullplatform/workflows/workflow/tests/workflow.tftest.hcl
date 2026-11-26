mock_provider "nullplatform" {
  mock_resource "nullplatform_workflow" {
    defaults = {
      id       = "wf_AbCd1234"
      revision = 3
    }
  }

  mock_resource "nullplatform_workflow_alias" {
    defaults = {
      webhook_urls = {
        on_webhook = "https://example.invalid/workflows/webhooks/wf_AbCd1234-notify/live/token"
      }
    }
  }
}

# A one-step workflow with a webhook trigger.
variables {
  name = "notify"

  definition = {
    steps = {
      on_webhook = {
        id         = "on_webhook"
        type       = "trigger"
        pluginType = "webhook"
        config     = { path = "/notify", mode = "start" }
      }
    }
    connections = []
  }
}

# Keys the module does not know about, nested objects, numbers and ${{ }}
# expressions reach the API as given: the module validates only the few keys
# it owns.
run "the_definition_is_sent_whole" {
  command = plan

  variables {
    definition = {
      semanticVersion = "1.0.0"
      inputs          = { count = { type = "number" } }
      variables       = { total = { initialValue = 0 } }
      outputs         = { result = "$${{ variables.total }}" }
      steps = {
        log_total = {
          id         = "log_total"
          pluginType = "log"
          config     = { message = "$${{ variables.total }}" }
        }
      }
      connections = []
    }
  }

  assert {
    condition     = nullplatform_workflow.this.definition == jsonencode(var.definition)
    error_message = "The definition must be sent as jsonencode of the object given"
  }

  assert {
    condition     = jsondecode(nullplatform_workflow.this.definition).variables.total.initialValue == 0
    error_message = "Numbers must reach the API as numbers"
  }

  assert {
    condition     = jsondecode(nullplatform_workflow.this.definition).steps.log_total.config.message == "$${{ variables.total }}"
    error_message = "An expression must reach the API untouched"
  }
}

run "the_record_fields_reach_the_workflow" {
  command = plan

  variables {
    nrn         = "organization=1:account=2"
    key         = "notify"
    description = "Tells someone"
    folder      = "/governance/notify"
  }

  assert {
    condition     = nullplatform_workflow.this.name == "notify" && nullplatform_workflow.this.key == "notify"
    error_message = "name and key must reach the workflow as given"
  }

  assert {
    condition     = nullplatform_workflow.this.nrn == "organization=1:account=2"
    error_message = "The workflow must live at the nrn given"
  }

  assert {
    condition     = nullplatform_workflow.this.description == "Tells someone" && nullplatform_workflow.this.path == "/governance/notify"
    error_message = "description and folder must reach the workflow as description and path"
  }
}

# nrn and path are Optional and Computed: without them the API sets the
# organization and keeps the folder, so their planned values are the API's
# (the mock provider's), and only key and description are checked here.
run "the_record_fields_default_to_none" {
  command = plan

  assert {
    condition     = nullplatform_workflow.this.key == null && nullplatform_workflow.this.description == null
    error_message = "Without key and description the workflow must have none"
  }
}

run "the_alias_serves_the_workflow_revision" {
  command = apply

  assert {
    condition     = length(nullplatform_workflow_alias.this) == 1
    error_message = "By default the module must create the alias"
  }

  assert {
    condition     = nullplatform_workflow_alias.this[0].name == "live" && nullplatform_workflow_alias.this[0].active == true
    error_message = "The alias must be live and active by default"
  }

  assert {
    condition     = nullplatform_workflow_alias.this[0].workflow_id == "wf_AbCd1234" && nullplatform_workflow_alias.this[0].revision == 3
    error_message = "The alias must serve the workflow's latest revision"
  }

  assert {
    condition     = output.alias == "live"
    error_message = "alias must be the alias's name"
  }
}

run "an_inactive_alias_is_created_inactive" {
  command = apply

  variables {
    active = false
  }

  assert {
    condition     = nullplatform_workflow_alias.this[0].active == false
    error_message = "active = false must reach the alias"
  }
}

run "the_alias_takes_the_name_given" {
  command = plan

  variables {
    alias = "prod"
  }

  assert {
    condition     = nullplatform_workflow_alias.this[0].name == "prod"
    error_message = "The alias must take the name given"
  }
}

run "without_an_alias_the_workflow_stands_alone" {
  command = apply

  variables {
    alias = null
  }

  assert {
    condition     = length(nullplatform_workflow_alias.this) == 0
    error_message = "alias = null must create no alias"
  }

  assert {
    condition     = output.alias == null && nonsensitive(output.webhook_urls) == {}
    error_message = "Without an alias the alias and the webhook urls must be empty"
  }

  assert {
    condition     = output.revision == 3
    error_message = "The revision must still be the workflow's"
  }
}

run "the_outputs_follow_the_resources" {
  command = apply

  assert {
    condition     = output.id == "wf_AbCd1234" && output.revision == 3
    error_message = "id and revision must be the workflow's"
  }

  assert {
    condition     = output.key == null
    error_message = "A workflow without key must output a null key"
  }

  assert {
    condition     = nonsensitive(output.webhook_urls)["on_webhook"] == "https://example.invalid/workflows/webhooks/wf_AbCd1234-notify/live/token"
    error_message = "webhook_urls must be the alias's"
  }
}

run "the_kinds_come_from_the_checklist_triggers" {
  command = apply

  variables {
    definition = {
      steps = {
        gate_items = {
          id         = "gate_items"
          type       = "trigger"
          pluginType = "np-checklist-trigger"
          config     = { nrn = "organization=1", kind = "payments-gate", pathPrefix = "/np/checklist/payments-gate" }
        }
        gate_validations = {
          id         = "gate_validations"
          type       = "trigger"
          pluginType = "np-checklist-trigger"
          config = {
            nrn        = "organization=1"
            kind       = "payments-ticket"
            action     = "checklist:item:validation_dispatched"
            pathPrefix = "/np/checklist/payments-ticket"
          }
        }
        both = {
          id         = "both"
          type       = "trigger"
          pluginType = "np-checklist-trigger"
          config = {
            nrn            = "organization=1"
            kind           = "payments-both"
            channelActions = ["checklist:item:dispatched", "checklist:item:validation_dispatched"]
            pathPrefix     = "/np/checklist/payments-both"
          }
        }
        channel_actions_win = {
          id         = "channel_actions_win"
          type       = "trigger"
          pluginType = "np-checklist-trigger"
          config = {
            nrn            = "organization=1"
            kind           = "payments-win"
            action         = "checklist:item:dispatched"
            channelActions = ["checklist:item:validation_dispatched"]
            pathPrefix     = "/np/checklist/payments-win"
          }
        }
        empty_channel_actions = {
          id         = "empty_channel_actions"
          type       = "trigger"
          pluginType = "np-checklist-trigger"
          config = {
            nrn            = "organization=1"
            kind           = "payments-empty"
            channelActions = []
            pathPrefix     = "/np/checklist/payments-empty"
          }
        }
        catch_all = {
          id         = "catch_all"
          type       = "trigger"
          pluginType = "np-checklist-trigger"
          config     = { nrn = "organization=1", kind = "*", pathPrefix = "/np/checklist/all" }
        }
        kind_from_a_variable = {
          id         = "kind_from_a_variable"
          type       = "trigger"
          pluginType = "np-checklist-trigger"
          config = {
            nrn            = "organization=1"
            kind           = "payments-$${{ vars.region }}"
            channelActions = ["checklist:item:dispatched", "checklist:item:validation_dispatched"]
            pathPrefix     = "/np/checklist/payments-region"
          }
        }
        not_a_checklist = {
          id         = "not_a_checklist"
          type       = "trigger"
          pluginType = "webhook"
          config     = { kind = "unrelated", path = "/hook" }
        }
      }
      connections = []
    }
  }

  assert {
    condition = output.checklist_item_kinds == {
      gate_items            = "payments-gate"
      both                  = "payments-both"
      empty_channel_actions = "payments-empty"
    }
    error_message = "checklist_item_kinds must hold the checklist triggers that listen to item dispatches, by step id"
  }

  assert {
    condition = output.checklist_validation_kinds == {
      gate_validations    = "payments-ticket"
      both                = "payments-both"
      channel_actions_win = "payments-win"
    }
    error_message = "checklist_validation_kinds must hold the checklist triggers that listen to validation dispatches, with channelActions overriding action"
  }

  assert {
    condition     = !contains(keys(output.checklist_item_kinds), "kind_from_a_variable") && !contains(keys(output.checklist_validation_kinds), "kind_from_a_variable")
    error_message = "A kind with a $${{ }} expression is resolved by the engine at activation: it must be in neither output"
  }
}

run "a_workflow_without_checklist_triggers_has_no_kinds" {
  command = apply

  assert {
    condition     = length(output.checklist_item_kinds) == 0 && length(output.checklist_validation_kinds) == 0
    error_message = "Without checklist triggers the kinds must be empty"
  }
}

run "the_checklist_gate_example_plans" {
  command = plan

  module {
    source = "./examples/checklist-gate"
  }
}

run "the_webhook_trigger_example_plans" {
  command = plan

  module {
    source = "./examples/webhook-trigger"
  }
}

run "a_definition_without_steps_is_refused" {
  command = plan

  variables {
    definition = { connections = [] }
  }

  expect_failures = [var.definition]
}

run "steps_as_a_list_are_refused" {
  command = plan

  variables {
    definition = {
      steps = [{ id = "a", pluginType = "log" }]
    }
  }

  expect_failures = [var.definition]
}

run "a_definition_passed_as_a_json_string_is_refused" {
  command = plan

  variables {
    definition = "{\"steps\": {}}"
  }

  expect_failures = [var.definition]
}

run "a_definition_with_a_record_key_is_refused" {
  command = plan

  variables {
    definition = {
      name  = "notify"
      steps = {}
    }
  }

  expect_failures = [var.definition]
}

run "a_definition_with_a_derived_key_is_refused" {
  command = plan

  variables {
    definition = {
      triggers = []
      steps    = {}
    }
  }

  expect_failures = [var.definition]
}

run "a_checklist_trigger_without_an_nrn_is_refused" {
  command = plan

  variables {
    definition = {
      steps = {
        gate = {
          id         = "gate"
          type       = "trigger"
          pluginType = "np-checklist-trigger"
          config     = { kind = "payments-gate" }
        }
      }
    }
  }

  expect_failures = [var.definition]
}

run "a_channel_trigger_without_an_alias_is_refused" {
  command = plan

  variables {
    alias = null

    definition = {
      steps = {
        deployed = {
          id         = "deployed"
          type       = "trigger"
          pluginType = "np-deployment-trigger"
          config     = { nrn = "organization=1" }
        }
      }
    }
  }

  expect_failures = [nullplatform_workflow.this]
}

run "a_webhook_trigger_without_an_alias_is_allowed" {
  command = plan

  variables {
    alias = null
  }
}

run "the_alias_latest_is_refused" {
  command = plan

  variables {
    alias = "latest"
  }

  expect_failures = [var.alias]
}

run "an_empty_alias_is_refused" {
  command = plan

  variables {
    alias = ""
  }

  expect_failures = [var.alias]
}
