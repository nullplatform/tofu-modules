mock_provider "google" {}

variables {
  project_id  = "myorg-project"
  zone_name   = "myorg-zone"
  domain_name = "myorg.example.com"
}

run "dns_name_has_trailing_dot" {
  command = plan

  assert {
    condition     = google_dns_managed_zone.zone.dns_name == "myorg.example.com."
    error_message = "dns_name should have trailing dot"
  }
}

run "default_visibility_is_public" {
  command = plan

  assert {
    condition     = google_dns_managed_zone.zone.visibility == "public"
    error_message = "Default visibility should be public"
  }
}

run "private_zone_visibility" {
  command = plan

  variables {
    visibility = "private"
  }

  assert {
    condition     = google_dns_managed_zone.zone.visibility == "private"
    error_message = "Should accept private visibility"
  }
}

run "zone_uses_provided_name" {
  command = plan

  assert {
    condition     = google_dns_managed_zone.zone.name == "myorg-zone"
    error_message = "Zone name should match zone_name variable"
  }
}

run "zone_name_derived_from_domain_when_omitted" {
  command = plan

  variables {
    zone_name = null
  }

  assert {
    condition     = google_dns_managed_zone.zone.name == "myorg-example-com"
    error_message = "Zone name should derive from domain_name by replacing dots with dashes when zone_name is null"
  }
}

run "labels_applied_from_tags" {
  command = plan

  variables {
    tags = {
      env  = "test"
      team = "platform"
    }
  }

  assert {
    condition     = google_dns_managed_zone.zone.labels["env"] == "test"
    error_message = "Labels should be applied from tags variable"
  }
}
