mock_provider "nullplatform" {}

variables {
  type = "agent"
  nrn  = "organization=myorg:account=myaccount:namespace=mynamespace"
}

################################################################################
# Name tests
################################################################################

run "agent_api_key" {
  command = plan

  assert {
    condition     = nullplatform_api_key.this.name == "AGENT"
    error_message = "Agent API key name should be 'AGENT'"
  }
}

run "scope_notification_api_key" {
  command = plan

  variables {
    type               = "scope_notification"
    specification_slug = "k8s"
  }

  assert {
    condition     = nullplatform_api_key.this.name == "SCOPE-NOTIFICATION-CHANNEL-K8S"
    error_message = "Scope notification API key name should be 'SCOPE-NOTIFICATION-CHANNEL-K8S'"
  }
}

run "service_notification_api_key" {
  command = plan

  variables {
    type               = "service_notification"
    specification_slug = "PostgreSQL"
  }

  assert {
    condition     = nullplatform_api_key.this.name == "SERVICE-NOTIFICATION-CHANNEL-POSTGRESQL"
    error_message = "Service notification API key name should be 'SERVICE-NOTIFICATION-CHANNEL-POSTGRESQL'"
  }
}

run "custom_api_key" {
  command = plan

  variables {
    type              = "custom"
    custom_name       = "MY-CUSTOM-KEY"
    custom_role_slugs = ["controlplane:agent", "developer"]
    custom_tags = [
      { key = "team", value = "platform" }
    ]
  }

  assert {
    condition     = nullplatform_api_key.this.name == "MY-CUSTOM-KEY"
    error_message = "Custom API key name should be 'MY-CUSTOM-KEY'"
  }
}

################################################################################
# Tags tests — validate the dynamic tags block (the source of the tuple bug)
################################################################################

run "tags_always_include_managed_by" {
  command = plan

  assert {
    condition     = length([for t in nullplatform_api_key.this.tags : t if t.key == "managedBy" && t.value == "IaC"]) == 1
    error_message = "API key should always have managedBy=IaC tag"
  }
}

run "tags_derive_org_account_namespace_from_nrn" {
  command = plan

  assert {
    condition     = length([for t in nullplatform_api_key.this.tags : t if t.key == "organization" && t.value == "myorg"]) == 1
    error_message = "API key should have organization tag derived from NRN"
  }

  assert {
    condition     = length([for t in nullplatform_api_key.this.tags : t if t.key == "account" && t.value == "myaccount"]) == 1
    error_message = "API key should have account tag derived from NRN"
  }

  assert {
    condition     = length([for t in nullplatform_api_key.this.tags : t if t.key == "namespace" && t.value == "mynamespace"]) == 1
    error_message = "API key should have namespace tag derived from NRN"
  }
}

run "tags_merge_custom_tags" {
  command = plan

  variables {
    type        = "custom"
    custom_name = "MY-KEY"
    custom_role_slugs = ["developer"]
    custom_tags = [
      { key = "team", value = "platform" },
      { key = "env", value = "prod" },
    ]
  }

  assert {
    condition     = length([for t in nullplatform_api_key.this.tags : t if t.key == "managedBy"]) == 1
    error_message = "managedBy tag should be present alongside custom tags"
  }

  assert {
    condition     = length([for t in nullplatform_api_key.this.tags : t if t.key == "team" && t.value == "platform"]) == 1
    error_message = "Custom tag team=platform should be present"
  }

  assert {
    condition     = length([for t in nullplatform_api_key.this.tags : t if t.key == "env" && t.value == "prod"]) == 1
    error_message = "Custom tag env=prod should be present"
  }
}

################################################################################
# Grants tests — validate the dynamic grants block
################################################################################

run "agent_grants_count" {
  command = plan

  assert {
    condition     = length(nullplatform_api_key.this.grants) == 5
    error_message = "Agent API key should have 5 grants (controlplane:agent, developer, ops, secops, secrets-reader)"
  }
}

run "agent_grants_include_controlplane_agent" {
  command = plan

  assert {
    condition     = length([for g in nullplatform_api_key.this.grants : g if g.role_slug == "controlplane:agent"]) == 1
    error_message = "Agent API key should have grant for role 'controlplane:agent'"
  }
}

run "custom_grants_explicit_nrn" {
  command = plan

  variables {
    type        = "custom"
    nrn         = null
    custom_name = "MULTI-NRN-KEY"
    custom_grants = [
      { nrn = "organization=myorg:account=myaccount", role_slug = "developer" },
      { nrn = "organization=myorg:account=anotheraccount", role_slug = "ops" },
    ]
  }

  assert {
    condition     = length(nullplatform_api_key.this.grants) == 2
    error_message = "Custom API key with custom_grants should have exactly 2 grants"
  }

  assert {
    condition     = length([for g in nullplatform_api_key.this.grants : g if g.nrn == "organization=myorg:account=myaccount" && g.role_slug == "developer"]) == 1
    error_message = "Should have grant for organization=myorg:account=myaccount with role developer"
  }
}
