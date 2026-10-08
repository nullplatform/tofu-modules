mock_provider "nullplatform" {}
mock_provider "http" {}
mock_provider "external" {}

# The rendered template of an existing scope repo still carries api_key: the
# module must ignore it and send only var.api_key.
override_data {
  target = data.http.notification_channel_template
  values = {
    status_code   = 200
    response_body = "{}"
  }
}

override_data {
  target = data.external.notification_channel
  values = {
    result = {
      json = "{\"type\":\"agent\",\"source\":[\"service\"],\"configuration\":{\"api_key\":\"dummy-template-key\",\"command\":{\"type\":\"exec\",\"data\":{\"cmdline\":\"echo dummy\"}}},\"filters\":{\"service.specification.slug\":{\"$eq\":\"dummy\"}}}"
    }
  }
}

variables {
  nrn                      = "organization=1:account=2"
  scope_specification_id   = "dummy-specification-id"
  scope_specification_slug = "dummy-scope"
  tags_selectors           = { environment = "test" }
}

run "omitted_api_key_requests_a_managed_credential" {
  command = plan

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].api_key == null
    error_message = "Without api_key the channel must not carry a key, even when the template renders one."
  }
}

run "customer_api_key_is_still_sent" {
  command = plan

  variables {
    api_key = "dummy-customer-key"
  }

  assert {
    condition     = nonsensitive(nullplatform_notification_channel.from_template.configuration[0].agent[0].api_key) == "dummy-customer-key"
    error_message = "A configured api_key must reach the channel unchanged."
  }
}
