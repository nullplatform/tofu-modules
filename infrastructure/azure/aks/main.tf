
data "azurerm_client_config" "current" {}

module "aks" {
  source  = "Azure/aks/azurerm"
  version = "11.0.0"
  ############################################
  # Core / Naming
  ############################################
  resource_group_name = var.resource_group_name
  location            = var.location
  cluster_name        = var.cluster_name
  prefix              = var.prefix
  ############################################
  # Kubernetes version and upgrades
  ############################################

  kubernetes_version = var.kubernetes_version


  ############################################
  # API server and control plane
  ############################################

  api_server_authorized_ip_ranges = var.authorized_ip_ranges
  private_cluster_enabled         = var.private_cluster_enabled

  ############################################
  # RBAC / AAD / OIDC / Workload Identity
  ############################################
  role_based_access_control_enabled = true
  rbac_aad_azure_rbac_enabled       = false
  rbac_aad_tenant_id                = data.azurerm_client_config.current.tenant_id
  workload_identity_enabled         = true
  oidc_issuer_enabled               = var.oidc_issuer_enabled
  
  ############################################
  # Virtual network
  ############################################
  vnet_subnet = {
    id = var.vnet_subnet_id
  }

  ############################################
  # Agent (system) pool defaults
  ############################################
  agents_size                 = var.system_pool_vm_size
  temporary_name_for_rotation = "tmpnodepool"
  agents_pool_max_surge       = "10%"

  ############################################
  # Node pools (user workloads)
  ############################################
  node_pools = {
    cluster_node_pool = {
      name                 = "nodepool"
      vm_size              = var.user_pool_vm_size
      auto_scaling_enabled = true
      min_count            = 1
      max_count            = 5
      node_count           = 2
      availability_zones   = ["1", "2", "3"]
      vnet_subnet_id       = var.vnet_subnet_id



      temporary_name_for_rotation = "tmpnodepool"
    }



  }

  ############################################
  # Tags
  ############################################
  tags = var.tags

}
