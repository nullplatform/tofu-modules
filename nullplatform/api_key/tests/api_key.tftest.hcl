mock_provider "nullplatform" {}

variables {
  type = "agent"
  nrn  = "organization=myorg:account=myaccount:namespace=mynamespace"
}

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
