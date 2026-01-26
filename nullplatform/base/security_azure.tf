###############################################################################
# AZURE NETWORK SECURITY GROUPS FOR ISTIO GATEWAYS
# These NSGs restrict the health check port (15021) to VNet CIDR
# while allowing HTTPS (443) traffic as needed.
###############################################################################

locals {
  create_azure_security = var.gateway_security_enabled && var.k8s_provider == "aks"
}

###############################################################################
# DATA SOURCES - Derive VNet and CIDR from cluster name
###############################################################################

# Get AKS cluster info
data "azurerm_kubernetes_cluster" "this" {
  count               = local.create_azure_security ? 1 : 0
  name                = var.cluster_name
  resource_group_name = var.resource_group_name

  lifecycle {
    precondition {
      condition     = var.cluster_name != ""
      error_message = "cluster_name is required when gateway_security_enabled is true and k8s_provider is 'aks'."
    }
    precondition {
      condition     = var.resource_group_name != ""
      error_message = "resource_group_name is required when gateway_security_enabled is true and k8s_provider is 'aks'."
    }
  }
}

locals {
  # Parse the subnet ID to extract VNet info
  # Format: /subscriptions/{sub}/resourceGroups/{rg}/providers/Microsoft.Network/virtualNetworks/{vnet}/subnets/{subnet}
  azure_subnet_id_parts = local.create_azure_security ? split("/", data.azurerm_kubernetes_cluster.this[0].agent_pool_profile[0].vnet_subnet_id) : []
  azure_vnet_name       = local.create_azure_security ? local.azure_subnet_id_parts[8] : ""
  azure_vnet_rg         = local.create_azure_security ? local.azure_subnet_id_parts[4] : ""
}

# Get VNet info to derive address space
data "azurerm_virtual_network" "this" {
  count               = local.create_azure_security ? 1 : 0
  name                = local.azure_vnet_name
  resource_group_name = local.azure_vnet_rg
}

locals {
  # Derived values from data sources
  azure_location  = local.create_azure_security ? data.azurerm_kubernetes_cluster.this[0].location : ""
  azure_vnet_cidr = local.create_azure_security ? data.azurerm_virtual_network.this[0].address_space[0] : ""

  # Use override if provided, otherwise use derived value
  effective_azure_location     = var.azure_location != "" ? var.azure_location : local.azure_location
  effective_azure_network_cidr = var.network_cidr != "" ? var.network_cidr : local.azure_vnet_cidr
}

# Network Security Group for Public Gateway (Azure/AKS)
# - Port 443 (HTTPS): Open to internet (0.0.0.0/0)
# - Port 15021 (Health Check): Restricted to VNet CIDR only
resource "azurerm_network_security_group" "public_gateway" {
  count = local.create_azure_security && var.gateways_enabled ? 1 : 0

  name                = "${var.cluster_name}-istio-public-gateway"
  location            = local.effective_azure_location
  resource_group_name = var.resource_group_name

  tags = {
    Name      = "${var.cluster_name}-istio-public-gateway"
    ManagedBy = "terraform"
  }
}

resource "azurerm_network_security_rule" "public_gateway_https" {
  count = local.create_azure_security && var.gateways_enabled ? 1 : 0

  name                        = "allow-https-internet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.public_gateway[0].name
}

resource "azurerm_network_security_rule" "public_gateway_health_check" {
  count = local.create_azure_security && var.gateways_enabled ? 1 : 0

  name                        = "allow-health-check-vnet"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "15021"
  source_address_prefix       = local.effective_azure_network_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.public_gateway[0].name
}

resource "azurerm_network_security_rule" "public_gateway_deny_health_check_internet" {
  count = local.create_azure_security && var.gateways_enabled ? 1 : 0

  name                        = "deny-health-check-internet"
  priority                    = 120
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "15021"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.public_gateway[0].name
}

# Network Security Group for Private/Internal Gateway (Azure/AKS)
# - Port 443 (HTTPS): Restricted to VNet CIDR only
# - Port 15021 (Health Check): Restricted to VNet CIDR only
resource "azurerm_network_security_group" "private_gateway" {
  count = local.create_azure_security && var.gateway_internal_enabled ? 1 : 0

  name                = "${var.cluster_name}-istio-private-gateway"
  location            = local.effective_azure_location
  resource_group_name = var.resource_group_name

  tags = {
    Name      = "${var.cluster_name}-istio-private-gateway"
    ManagedBy = "terraform"
  }
}

resource "azurerm_network_security_rule" "private_gateway_https" {
  count = local.create_azure_security && var.gateway_internal_enabled ? 1 : 0

  name                        = "allow-https-vnet"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "443"
  source_address_prefix       = local.effective_azure_network_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_gateway[0].name
}

resource "azurerm_network_security_rule" "private_gateway_health_check" {
  count = local.create_azure_security && var.gateway_internal_enabled ? 1 : 0

  name                        = "allow-health-check-vnet"
  priority                    = 110
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "15021"
  source_address_prefix       = local.effective_azure_network_cidr
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_gateway[0].name
}

resource "azurerm_network_security_rule" "private_gateway_deny_all" {
  count = local.create_azure_security && var.gateway_internal_enabled ? 1 : 0

  name                        = "deny-all-internet"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Deny"
  protocol                    = "*"
  source_port_range           = "*"
  destination_port_range      = "*"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = var.resource_group_name
  network_security_group_name = azurerm_network_security_group.private_gateway[0].name
}
