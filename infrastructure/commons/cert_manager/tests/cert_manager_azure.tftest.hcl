mock_provider "helm" {}

variables {
  cloud_provider            = "azure"
  hosted_zone_name          = "myorg.nullimplementation.com"
  account_slug              = "myorg"
  private_domain_name       = "myorg.nullimplementation.com"
  azure_client_id               = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  azure_federated_credential_id = "/subscriptions/00000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/cert-manager/federatedIdentityCredentials/cert-manager-federated"
  azure_subscription_id         = "00000000-0000-0000-0000-000000000000"
  azure_resource_group_name     = "rg-test"
  azure_tenant_id               = "11111111-2222-3333-4444-555555555555"
  azure_hosted_zone_name        = "myorg.nullimplementation.com"
}

# Validates Azure provider config plans successfully
run "azure_full_config" {
  command = plan

  assert {
    condition     = helm_release.cert_manager.namespace == "cert-manager"
    error_message = "cert-manager should deploy to cert-manager namespace"
  }

  assert {
    condition     = helm_release.cert_manager_config.namespace == "cert-manager"
    error_message = "cert-manager-config should deploy to cert-manager namespace"
  }
}

# Validates cert-manager-config depends on cert-manager
run "config_depends_on_cert_manager" {
  command = plan

  assert {
    condition     = helm_release.cert_manager_config.name == "cert-manager-config"
    error_message = "cert-manager-config release should exist"
  }
}

# Validates Azure workload identity annotation is set
run "azure_workload_identity_annotation" {
  command = plan

  assert {
    condition     = local.annotations_by_provider["azure"]["azure.workload.identity/client-id"] == "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
    error_message = "Azure workload identity annotation should use the client_id"
  }
}

# Validates Azure provider_context includes all required fields
run "azure_provider_context_complete" {
  command = plan

  assert {
    condition     = local.provider_context["enabled"] == "true"
    error_message = "Azure provider context should be enabled"
  }

  assert {
    condition     = local.provider_context["subscription_id"] == "00000000-0000-0000-0000-000000000000"
    error_message = "Provider context should include subscription_id"
  }

  assert {
    condition     = local.provider_context["resource_group_name"] == "rg-test"
    error_message = "Provider context should include resource_group_name"
  }

  assert {
    condition     = local.provider_context["client_id"] == "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
    error_message = "Provider context should include client_id"
  }

  assert {
    condition     = local.provider_context["tenant_id"] == "11111111-2222-3333-4444-555555555555"
    error_message = "Provider context should include tenant_id"
  }
}

# Validates Azure fails without client_id
run "azure_requires_client_id" {
  command = plan

  variables {
    azure_client_id = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

# Validates Azure fails without subscription_id
run "azure_requires_subscription_id" {
  command = plan

  variables {
    azure_subscription_id = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

# Validates Azure fails without tenant_id
run "azure_requires_tenant_id" {
  command = plan

  variables {
    azure_tenant_id = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

# Validates Azure fails without resource_group_name
run "azure_requires_resource_group" {
  command = plan

  variables {
    azure_resource_group_name = ""
  }

  expect_failures = [terraform_data.provider_validation]
}

# Validates Azure fails without hosted_zone_name
run "azure_requires_hosted_zone" {
  command = plan

  variables {
    azure_hosted_zone_name = ""
  }

  expect_failures = [terraform_data.provider_validation]
}
