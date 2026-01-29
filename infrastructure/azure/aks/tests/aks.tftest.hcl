# TODO: Enable once mock_provider supports generating valid Azure Resource IDs.
# The upstream Azure/aks/azurerm module validates resource ID formats internally,
# but mock_provider generates random strings that fail those validations.
# This requires either mock_provider improvements or integration tests with real credentials.
#
# mock_provider "azurerm" {
#   override_data {
#     target = data.azurerm_client_config.current
#     values = {
#       tenant_id = "11111111-2222-3333-4444-555555555555"
#     }
#   }
# }
#
# variables {
#   subscription_id     = "00000000-0000-0000-0000-000000000000"
#   resource_group_name = "rg-test"
#   location            = "eastus2"
#   cluster_name        = "test-cluster"
#   vnet_subnet_id      = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.Network/virtualNetworks/vnet/subnets/subnet-1"
# }
#
# run "minimal_config_plans" {
#   command = plan
# }
#
# run "no_acr_when_null" {
#   command = plan
#   variables {
#     acr_id = null
#   }
# }
#
# run "acr_attached_when_provided" {
#   command = plan
#   variables {
#     acr_id = "/subscriptions/00000000-0000-0000-0000-000000000000/resourceGroups/rg-test/providers/Microsoft.ContainerRegistry/registries/myacr"
#   }
# }
#
# run "custom_vm_sizes" {
#   command = plan
#   variables {
#     system_pool_vm_size = "Standard_B2ms"
#     user_pool_vm_size   = "Standard_B2ms"
#   }
# }
#
# run "private_cluster" {
#   command = plan
#   variables {
#     private_cluster_enabled = true
#   }
# }
