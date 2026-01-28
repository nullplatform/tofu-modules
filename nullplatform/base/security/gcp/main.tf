###############################################################################
# GCP FIREWALL RULES FOR ISTIO GATEWAYS
# These firewall rules restrict the health check port (15021) to VPC CIDR
# while allowing HTTPS (443) traffic as needed.
###############################################################################

locals {
  need_data = var.gateways_enabled || var.gateway_internal_enabled
  # GCP health check ranges that need access for load balancer health checks
  gcp_health_check_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

###############################################################################
# DATA SOURCES - Derive network and CIDR from cluster name
###############################################################################

# Get GKE cluster info
data "google_container_cluster" "this" {
  count    = local.need_data ? 1 : 0
  name     = var.cluster_name
  location = var.gcp_region
  project  = var.gcp_project_id

  lifecycle {
    precondition {
      condition     = var.cluster_name != ""
      error_message = "cluster_name is required."
    }
    precondition {
      condition     = var.gcp_project_id != ""
      error_message = "gcp_project_id is required."
    }
    precondition {
      condition     = var.gcp_region != ""
      error_message = "gcp_region is required."
    }
  }
}

# Get subnetwork info to derive CIDR
data "google_compute_subnetwork" "this" {
  count   = local.need_data ? 1 : 0
  name    = data.google_container_cluster.this[0].subnetwork
  region  = var.gcp_region
  project = var.gcp_project_id
}

locals {
  # Derived values from data sources
  gcp_network_name = local.need_data ? data.google_container_cluster.this[0].network : ""
  gcp_subnet_cidr  = local.need_data ? data.google_compute_subnetwork.this[0].ip_cidr_range : ""

  # Use override if provided, otherwise use derived value
  effective_gcp_network_name = var.gcp_network_name != "" ? var.gcp_network_name : local.gcp_network_name
  effective_gcp_network_cidr = var.network_cidr != "" ? var.network_cidr : local.gcp_subnet_cidr
}

###############################################################################
# PUBLIC GATEWAY
###############################################################################

# Firewall Rules for Public Gateway (GCP/GKE)
# - Port 443 (HTTPS): Open to internet (0.0.0.0/0)
# - Port 15021 (Health Check): Restricted to VPC CIDR + GCP health check ranges
resource "google_compute_firewall" "public_gateway_https" {
  count = var.gateways_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-public-https"
  project     = var.gcp_project_id
  network     = local.effective_gcp_network_name
  description = "Allow HTTPS traffic from internet to Istio public gateway"

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.cluster_name}-istio-public-gateway"]
}

resource "google_compute_firewall" "public_gateway_health_check" {
  count = var.gateways_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-public-health"
  project     = var.gcp_project_id
  network     = local.effective_gcp_network_name
  description = "Allow health check traffic from VPC and GCP health checkers to Istio public gateway"

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["15021"]
  }

  # Allow from VPC CIDR and GCP health check ranges
  source_ranges = concat([local.effective_gcp_network_cidr], local.gcp_health_check_ranges)
  target_tags   = ["${var.cluster_name}-istio-public-gateway"]
}

# Deny rule for health check from internet (lower priority than allow rule)
resource "google_compute_firewall" "public_gateway_deny_health_check" {
  count = var.gateways_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-public-deny-health"
  project     = var.gcp_project_id
  network     = local.effective_gcp_network_name
  description = "Deny health check traffic from internet to Istio public gateway"

  direction = "INGRESS"
  priority  = 1100

  deny {
    protocol = "tcp"
    ports    = ["15021"]
  }

  source_ranges = ["0.0.0.0/0"]
  target_tags   = ["${var.cluster_name}-istio-public-gateway"]
}

###############################################################################
# PRIVATE GATEWAY
###############################################################################

# Firewall Rules for Private/Internal Gateway (GCP/GKE)
# - Port 443 (HTTPS): Restricted to VPC CIDR only
# - Port 15021 (Health Check): Restricted to VPC CIDR + GCP health check ranges
resource "google_compute_firewall" "private_gateway_https" {
  count = var.gateway_internal_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-private-https"
  project     = var.gcp_project_id
  network     = local.effective_gcp_network_name
  description = "Allow HTTPS traffic from VPC to Istio private gateway"

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = [local.effective_gcp_network_cidr]
  target_tags   = ["${var.cluster_name}-istio-private-gateway"]
}

resource "google_compute_firewall" "private_gateway_health_check" {
  count = var.gateway_internal_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-private-health"
  project     = var.gcp_project_id
  network     = local.effective_gcp_network_name
  description = "Allow health check traffic from VPC and GCP health checkers to Istio private gateway"

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["15021"]
  }

  # Allow from VPC CIDR and GCP health check ranges (needed for internal LB)
  source_ranges = concat([local.effective_gcp_network_cidr], local.gcp_health_check_ranges)
  target_tags   = ["${var.cluster_name}-istio-private-gateway"]
}
