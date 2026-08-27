
data "azurerm_client_config" "current" {}

#tfsec:ignore:azure-container-limit-authorized-ips
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
  oidc_issuer_enabled               = true

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
  temporary_name_for_rotation = "systempool"
  agents_pool_max_surge       = "10%"
  agents_availability_zones   = var.system_pool_zones
  agents_count                = var.system_pool_node_count

  ############################################
  # Node pools (user workloads)
  ############################################
  node_pools = {
    cluster_node_pool = {
      name                 = "nodepool"
      vm_size              = var.user_pool_vm_size
      auto_scaling_enabled = true
      min_count            = var.user_pool_min_count
      max_count            = var.user_pool_max_count
      #node_count           = 3
      # The upstream module calls this `zones`. `availability_zones` was silently
      # discarded -- Terraform drops attributes that are absent from an
      # object({...}) type instead of failing -- so this pool has been created
      # with no zone spread at all. See var.node_pool_zones.
      zones                       = var.node_pool_zones
      vnet_subnet                 = { id = var.vnet_subnet_id }
      upgrade_settings            = { max_surge = "10%", drain_timeout_in_minutes = 0, node_soak_duration_in_minutes = 0 }
      temporary_name_for_rotation = "poolrot"
    }

  }

  # attach_acr null (default) keeps the legacy "attach iff acr_id is non-null" behaviour;
  # setting it true makes the for_each key set plan-stable when acr_id is known-after-apply.
  attached_acr_id_map = (var.attach_acr != null ? var.attach_acr : var.acr_id != null) ? { acr = var.acr_id } : {}
  # The node subnet is always needed. Anything else the cloud-provider has to
  # write into -- typically the subnet an internal load balancer is pinned to --
  # has to be passed in, or provisioning that LB fails with a 403 on
  # `virtualNetworks/subnets/read`.
  network_contributor_role_assigned_subnet_ids = merge(
    { subnet = var.vnet_subnet_id },
    var.additional_network_contributor_subnet_ids,
  )

  ############################################
  # Tags
  ############################################
  tags = var.tags

}
