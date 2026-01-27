############################################
# Security Modules
############################################

module "security_aws" {
  count  = var.gateway_security_enabled && var.k8s_provider == "eks" ? 1 : 0
  source = "./security_aws"

  cluster_name             = var.cluster_name
  vpc_id                   = var.vpc_id
  network_cidr             = var.network_cidr
  gateways_enabled         = var.gateways_enabled
  gateway_internal_enabled = var.gateway_internal_enabled
}

module "security_azure" {
  count  = var.gateway_security_enabled && contains(["aks", "aro"], var.k8s_provider) ? 1 : 0
  source = "./security_azure"

  cluster_name             = var.cluster_name
  resource_group_name      = var.resource_group_name
  azure_location           = var.azure_location
  network_cidr             = var.network_cidr
  gateways_enabled         = var.gateways_enabled
  gateway_internal_enabled = var.gateway_internal_enabled
}

module "security_gcp" {
  count  = var.gateway_security_enabled && var.k8s_provider == "gke" ? 1 : 0
  source = "./security_gcp"

  cluster_name             = var.cluster_name
  gcp_project_id           = var.gcp_project_id
  gcp_region               = var.gcp_region
  gcp_network_name         = var.gcp_network_name
  network_cidr             = var.network_cidr
  gateways_enabled         = var.gateways_enabled
  gateway_internal_enabled = var.gateway_internal_enabled
}

############################################
# Helm Release
############################################

resource "helm_release" "base" {
  name       = "nullplatform-base"
  chart      = "nullplatform-base"
  repository = "https://nullplatform.github.io/helm-charts"
  namespace  = var.namespace
  version    = var.nullplatform_base_helm_version

  create_namespace  = true
  disable_webhooks  = false
  force_update      = true
  wait              = true
  wait_for_jobs     = true
  timeout           = 600
  atomic            = true
  cleanup_on_fail   = true
  replace           = true
  recreate_pods     = true
  reset_values      = true
  reuse_values      = false
  dependency_update = true
  max_history       = 10
  values            = [local.nullplatform_base_values]
}