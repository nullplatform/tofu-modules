module "gke" {
  source  = "terraform-google-modules/kubernetes-engine/google//modules/private-cluster"
  version = "~> 33.0"

  project_id = var.project_id
  name       = var.cluster_name
  region     = var.region

  network           = var.network_name
  subnetwork        = var.subnetwork_name
  ip_range_pods     = var.ip_range_pods
  ip_range_services = var.ip_range_services

  # Private cluster with public endpoint
  enable_private_endpoint = false
  enable_private_nodes    = true
  master_ipv4_cidr_block  = "172.16.0.0/28"

  # Security defaults
  remove_default_node_pool = true
  initial_node_count       = 1

  master_authorized_networks = var.master_authorized_networks

  node_pools = var.node_pools

  logging_service = "none"
}
