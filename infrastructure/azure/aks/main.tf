
data "azurerm_client_config" "current" {}

module "aks" {
  # ✅ Pin the module version to avoid breaking changes on upgrades
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
  # Kubernetes version & upgrades
  ############################################

  kubernetes_version = var.kubernetes_version


  ############################################
  # API Server & Control Plane
  ############################################

  api_server_authorized_ip_ranges = var.authorized_ip_ranges
  private_cluster_enabled         = var.private_cluster_enabled

  ############################################
  # RBAC / AAD / OIDC / Workload Identity
  ############################################
  role_based_access_control_enabled = true
  rbac_aad_azure_rbac_enabled       = false
  rbac_aad_tenant_id                = data.azurerm_client_config.current.tenant_id


  workload_identity_enabled = true
  oidc_issuer_enabled       = var.oidc_issuer_enabled




  # Subnet para el control plane / kubelets
  vnet_subnet = {
    id = var.vnet_subnet_id
  }

  ############################################
  # Agent (system) pool defaults
  ############################################
  agents_size                 = var.system_pool_vm_size # e.g., "Standard_D4s_v5"
  temporary_name_for_rotation = "tmpnodepool"
  agents_pool_max_surge       = "10%"

  ############################################
  # Node pools (user workloads)
  ############################################
  node_pools = {
    cluster_node_pool = {
      name                 = "nodepool"
      vm_size              = var.user_pool_vm_size # e.g., "Standard_D4s_v5"
      auto_scaling_enabled = true
      min_count            = 1
      max_count            = 10
      node_count           = 2
      availability_zones   = ["1", "2", "3"]
      vnet_subnet_id       = var.vnet_subnet_id

      # ✅ Mejora de upgrades (si el módulo expone upgrade_settings)
      #upgrade_settings = {
      #  max_unavailable = 1 # acelera los upgrades de nodepool
      # }
      #
      # ✅ Etiquetas y taints/labels para scheduling avanzado
      # node_labels = {
      #   "workload" = "general"
      # }
      # node_taints = [
      #   "workload=general:NoSchedule"
      # ]

      temporary_name_for_rotation = "tmpnodepool"
    }

    # ✅ (Opcional) Pool spot para cargas tolerantes a interrupciones
    # spot_pool = {
    #   name                  = "spot"
    #   vm_size               = var.spot_pool_vm_size
    #   enable_node_public_ip = false
    #   auto_scaling_enabled  = true
    #   min_count             = 0
    #   max_count             = 20
    #   node_labels = {
    #     "workload" = "spot"
    #   }
    #   node_taints = [
    #     "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
    #   ]
    #   priority        = "Spot"
    #   eviction_policy = "Delete"
    #   vnet_subnet_id  = var.vnet_subnet_id
    # }
  }

  ############################################
  # Tags
  ############################################
  tags = var.tags # permite agregar/overrides desde tfvars


  ############################################
  # Add-ons / Integraciones (activar si tu módulo los soporta)
  ############################################
  # azure_policy_enabled        = true  # Enforce guardrails (Gatekeeper)
  # oms_log_analytics_workspace_id = var.log_analytics_workspace_id  # Container Insights
  # http_application_routing_enabled = false # obsoleto en la mayoría de escenarios
  # key_vault_secrets_provider_enabled = true # CSI driver para secretos de KV
}
