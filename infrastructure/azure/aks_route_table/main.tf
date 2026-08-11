data "azurerm_resources" "aks_route_table" {
  resource_group_name = var.node_resource_group
  type                = "Microsoft.Network/routeTables"
}

resource "terraform_data" "trigger" {
  # Key on the actual attachment (subnet + route table id), not timestamp(),
  # which replaced every plan and kept the stack from converging (#474).
  triggers_replace = [var.subnet_id, data.azurerm_resources.aks_route_table.resources[0].id]
}

resource "azapi_update_resource" "aks_subnet_route_table" {
  type        = "Microsoft.Network/virtualNetworks/subnets@2024-01-01"
  resource_id = var.subnet_id

  body = {
    properties = {
      routeTable = {
        id = data.azurerm_resources.aks_route_table.resources[0].id
      }
    }
  }

  lifecycle {
    replace_triggered_by = [terraform_data.trigger]
  }
}
