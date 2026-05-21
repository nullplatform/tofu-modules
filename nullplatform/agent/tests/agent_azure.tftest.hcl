mock_provider "helm" {}

variables {
  api_key        = "test-api-key"
  cluster_name   = "test-cluster"
  nrn            = "organization=1:account=2:namespace=3"
  tags_selectors = { env = "test" }
  image_tag      = "latest"
  cloud_provider = "azure"

  azure_client_id               = "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
  azure_federated_credential_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ManagedIdentity/userAssignedIdentities/agent/federatedIdentityCredentials/agent-federated"
  azure_subscription_id         = "00000000-0000-0000-0000-000000000000"
  azure_resource_group          = "rg-test"
  azure_tenant_id               = "11111111-2222-3333-4444-555555555555"
  private_gateway_name          = "private-gateway"
  public_gateway_name           = "public-gateway"
  private_hosted_zone_rg        = "rg-test"
}

# Default Azure mode is Workload Identity — no client_secret required.
# This is the central contract this PR enforces.
run "wi_default_does_not_require_client_secret" {
  command = plan

  assert {
    condition     = local.azure_workload_identity_active == true
    error_message = "Azure default must be Workload Identity"
  }

  assert {
    condition     = !contains(keys(local.cloud_config.azure), "AZURE_CLIENT_SECRET")
    error_message = "AZURE_CLIENT_SECRET must NOT be injected into the agent Secret in WI mode"
  }

  assert {
    condition     = !contains(keys(local.all_config), "AZURE_CLIENT_SECRET")
    error_message = "AZURE_CLIENT_SECRET must NOT appear in the final config map in WI mode"
  }
}

# WI mode wires the Azure Workload Identity webhook contract into the chart values.
run "wi_default_sets_workload_identity_annotation_and_pod_label" {
  command = plan

  assert {
    condition     = local.service_account_annotations["azure.workload.identity/client-id"] == "aaaaaaaa-bbbb-cccc-dddd-eeeeeeeeeeee"
    error_message = "ServiceAccount must be annotated with azure.workload.identity/client-id pointing at the managed identity client_id"
  }

  assert {
    condition     = local.pod_labels["azure.workload.identity/use"] == "true"
    error_message = "Pod must be labeled azure.workload.identity/use=true so the WI webhook injects the federated token env vars"
  }
}

# WI mode requires the federated identity credential ID — caller must wire it from
# infrastructure/azure/iam to create the SA → managed identity binding.
run "wi_mode_requires_federated_credential_id" {
  command = plan

  variables {
    azure_federated_credential_id = ""
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

# When SP is explicitly opted in, the secret IS required.
run "sp_opt_in_requires_client_secret" {
  command = plan

  variables {
    azure_workload_identity_enabled = false
    azure_client_secret             = null
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

# Empty-string client_secret is treated as missing in SP mode (defensive).
run "sp_opt_in_rejects_empty_client_secret" {
  command = plan

  variables {
    azure_workload_identity_enabled = false
    azure_client_secret             = ""
  }

  expect_failures = [terraform_data.cross_variable_validation]
}

# SP mode wires the secret into the agent's env config, and skips WI annotations.
run "sp_opt_in_with_secret_injects_credential_and_skips_wi_wiring" {
  command = plan

  variables {
    azure_workload_identity_enabled = false
    azure_client_secret             = "test-secret-value"
    azure_federated_credential_id   = ""
  }

  assert {
    condition     = local.cloud_config.azure["AZURE_CLIENT_SECRET"] == "test-secret-value"
    error_message = "SP mode must inject AZURE_CLIENT_SECRET into the agent config"
  }

  assert {
    condition     = !contains(keys(local.service_account_annotations), "azure.workload.identity/client-id")
    error_message = "SP mode must not set the WI ServiceAccount annotation"
  }

  assert {
    condition     = length(local.pod_labels) == 0
    error_message = "SP mode must not set the WI pod label"
  }

  assert {
    condition     = local.azure_workload_identity_active == false
    error_message = "azure_workload_identity_active must reflect the opt-out flag"
  }
}

# Non-credential Azure inputs are always required, regardless of auth mode.
run "azure_requires_client_id" {
  command = plan
  variables {
    azure_client_id = null
  }
  expect_failures = [terraform_data.cross_variable_validation]
}

run "azure_requires_subscription_id" {
  command = plan
  variables {
    azure_subscription_id = null
  }
  expect_failures = [terraform_data.cross_variable_validation]
}

run "azure_requires_tenant_id" {
  command = plan
  variables {
    azure_tenant_id = null
  }
  expect_failures = [terraform_data.cross_variable_validation]
}

run "azure_requires_resource_group" {
  command = plan
  variables {
    azure_resource_group = null
  }
  expect_failures = [terraform_data.cross_variable_validation]
}
