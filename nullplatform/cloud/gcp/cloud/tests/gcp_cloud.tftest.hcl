mock_provider "nullplatform" {}

variables {
  nrn         = "organization=myorg:account=myaccount"
  domain_name = "example.com"
  project_id  = "myorg-gcp-project"
}

run "gcp_provider_type" {
  command = plan

  assert {
    condition     = nullplatform_provider_config.gcp.type == "google-cloud-configuration"
    error_message = "Provider config type should be 'google-cloud-configuration'"
  }

  assert {
    condition     = nullplatform_provider_config.gcp.nrn == "organization=myorg:account=myaccount"
    error_message = "NRN should match input"
  }
}

run "attributes_contain_project" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.gcp.attributes, "myorg-gcp-project")
    error_message = "Attributes should contain the project ID"
  }
}

run "attributes_contain_domain" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.gcp.attributes, "example.com")
    error_message = "Attributes should contain the domain name"
  }
}

run "with_dns_zones" {
  command = plan

  variables {
    public_dns_zone_name  = "example-public"
    private_dns_zone_name = "example-private"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gcp.attributes, "example-public")
    error_message = "Attributes should contain public DNS zone name"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.gcp.attributes, "example-private")
    error_message = "Attributes should contain private DNS zone name"
  }
}

run "with_dimensions" {
  command = plan

  variables {
    dimensions = {
      "Environment" = "staging"
    }
  }

  assert {
    condition     = nullplatform_provider_config.gcp.dimensions["Environment"] == "staging"
    error_message = "Dimensions should contain Environment=staging"
  }
}
