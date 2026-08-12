# Standard cluster with manually managed node pools (default mode)
module "gke" {
  count = var.autopilot_enabled ? 0 : 1

  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 33.0"

  project_id          = var.project_id
  name                = var.cluster_name
  region              = var.location
  deletion_protection = var.deletion_protection_enabled

  network           = var.vpc_name
  subnetwork        = var.vpc_subnet_name
  ip_range_pods     = var.ip_range_pods
  ip_range_services = var.ip_range_services

  # Private cluster with public endpoint
  enable_private_endpoint = false
  enable_private_nodes    = true
  master_ipv4_cidr_block  = var.master_ipv4_cidr_block

  # Security defaults
  remove_default_node_pool = true
  initial_node_count       = 1

  master_authorized_networks = var.authorized_ip_ranges

  node_pools = var.node_pools

  cluster_resource_labels = var.tags

  # Service account with Artifact Registry access
  grant_registry_access  = true
  create_service_account = true
  logging_service        = "none"
}

# Autopilot cluster — GCP manages node provisioning/scaling per workload,
# so there is no node_pools equivalent here.
module "gke_autopilot" {
  count = var.autopilot_enabled ? 1 : 0

  source  = "terraform-google-modules/kubernetes-engine/google//modules/beta-autopilot-private-cluster"
  version = "~> 33.0"

  project_id          = var.project_id
  name                = var.cluster_name
  region              = var.location
  deletion_protection = var.deletion_protection_enabled

  network           = var.vpc_name
  subnetwork        = var.vpc_subnet_name
  ip_range_pods     = var.ip_range_pods
  ip_range_services = var.ip_range_services

  # Private cluster with public endpoint
  enable_private_endpoint = false
  enable_private_nodes    = true
  master_ipv4_cidr_block  = var.master_ipv4_cidr_block

  master_authorized_networks = var.authorized_ip_ranges

  cluster_resource_labels = var.tags

  # Service account with Artifact Registry access
  grant_registry_access  = true
  create_service_account = true
}
