mock_provider "nullplatform" {}

variables {
  nrn                             = "organization=myorg:account=myaccount"
  azure_resource_group_name       = "myorg-rg"
  private_dns_resource_group_name = "myorg-dns-rg"
}

run "azure_provider_type" {
  command = plan

  assert {
    condition     = nullplatform_provider_config.azure.type == "azure-configuration"
    error_message = "Provider config type should be 'azure-configuration'"
  }

  assert {
    condition     = nullplatform_provider_config.azure.nrn == "organization=myorg:account=myaccount"
    error_message = "NRN should match input"
  }
}

run "attributes_contain_resource_groups" {
  command = plan

  assert {
    condition     = strcontains(nullplatform_provider_config.azure.attributes, "myorg-rg")
    error_message = "Attributes should contain the resource group name"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.azure.attributes, "myorg-dns-rg")
    error_message = "Attributes should contain the private DNS resource group name"
  }
}

run "with_domain_name" {
  command = plan

  variables {
    domain_name = "example.com"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.azure.attributes, "example.com")
    error_message = "Attributes should contain the domain name"
  }
}

run "with_private_domain" {
  command = plan

  variables {
    domain_name         = "example.com"
    private_domain_name = "internal.example.com"
  }

  assert {
    condition     = strcontains(nullplatform_provider_config.azure.attributes, "internal.example.com")
    error_message = "Attributes should contain the private domain name"
  }
}

run "with_dimensions" {
  command = plan

  variables {
    dimensions = {
      "Environment" = "production"
    }
  }

  assert {
    condition     = nullplatform_provider_config.azure.dimensions["Environment"] == "production"
    error_message = "Dimensions should contain Environment=production"
  }
}
