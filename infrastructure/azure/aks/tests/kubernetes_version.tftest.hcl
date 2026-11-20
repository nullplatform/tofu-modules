mock_provider "azurerm" {}

variables {
  subscription_id     = "00000000-0000-0000-0000-000000000000"
  resource_group_name = "rg-test"
  location            = "eastus"
  cluster_name        = "test-cluster"
  vnet_subnet_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet/subnets/aks"
  kubernetes_version  = "1.32.7"
}

# No default: the control plane version is always the caller's decision (CLIEN-1176)
run "rejects_moving_kubernetes_version" {
  command = plan

  variables {
    kubernetes_version = "latest"
  }

  expect_failures = [var.kubernetes_version]
}

run "rejects_empty_kubernetes_version" {
  command = plan

  variables {
    kubernetes_version = ""
  }

  expect_failures = [var.kubernetes_version]
}
