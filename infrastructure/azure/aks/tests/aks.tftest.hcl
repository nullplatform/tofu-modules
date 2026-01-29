mock_provider "azurerm" {}

variables {
  subscription_id     = "00000000-0000-0000-0000-000000000000"
  resource_group_name = "rg-test"
  location            = "eastus2"
  cluster_name        = "test-cluster"
  vnet_subnet_id      = "/subscriptions/00000000/resourceGroups/rg/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet-1"
}

# Validates AKS plans successfully with minimal required variables
run "minimal_config_plans" {
  command = plan
}

# Validates RBAC is always enabled (hardcoded in module)
run "rbac_always_enabled" {
  command = plan

  assert {
    condition     = module.aks.rbac_enabled == true
    error_message = "RBAC must always be enabled"
  }
}

# Validates ACR integration is skipped when acr_id is null
run "no_acr_when_null" {
  command = plan

  variables {
    acr_id = null
  }

  assert {
    condition     = length(module.aks.attached_acr_id_map) == 0
    error_message = "ACR map should be empty when acr_id is null"
  }
}

# Validates ACR integration is configured when acr_id is provided
run "acr_attached_when_provided" {
  command = plan

  variables {
    acr_id = "/subscriptions/00000000/resourceGroups/rg/providers/Microsoft.ContainerRegistry/registries/myacr"
  }

  assert {
    condition     = length(module.aks.attached_acr_id_map) == 1
    error_message = "ACR map should have 1 entry when acr_id is provided"
  }
}

# Validates the subnet is assigned as network contributor
run "subnet_network_contributor_role" {
  command = plan

  assert {
    condition     = module.aks.network_contributor_role_assigned_subnet_ids["subnet"] == var.vnet_subnet_id
    error_message = "Subnet should be assigned network contributor role"
  }
}

# Validates workload identity is enabled by default
run "workload_identity_enabled" {
  command = plan

  assert {
    condition     = module.aks.workload_identity_enabled == true
    error_message = "Workload identity should be enabled by default"
  }
}

# Validates custom VM sizes are propagated
run "custom_vm_sizes" {
  command = plan

  variables {
    system_pool_vm_size = "Standard_B2ms"
    user_pool_vm_size   = "Standard_B2ms"
  }

  assert {
    condition     = module.aks.agents_size == "Standard_B2ms"
    error_message = "System pool VM size should be Standard_B2ms"
  }
}
