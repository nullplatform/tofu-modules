mock_provider "nullplatform" {}

variables {
  nrn            = "organization=1:account=2"
  tags_selectors = { environment = "test" }
}

run "omitted_api_key_requests_a_managed_credential" {
  command = plan

  assert {
    condition     = nullplatform_notification_channel.from_template.configuration[0].agent[0].api_key == null
    error_message = "Without api_key the channel must not carry a key, so the platform manages its credential."
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
