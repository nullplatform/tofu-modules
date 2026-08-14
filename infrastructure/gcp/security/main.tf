###############################################################################
# GCP FIREWALL RULES FOR ISTIO GATEWAYS
# These firewall rules restrict the health check port (15021) to VPC CIDR
# while allowing HTTPS (443) traffic as needed.
###############################################################################

locals {
  # GCP health check ranges that need access for load balancer health checks
  gcp_health_check_ranges = ["35.191.0.0/16", "130.211.0.0/22"]
}

###############################################################################
# DATA SOURCES - Derive network and CIDR from cluster name
###############################################################################

# Get GKE cluster info.
#
# Skipped entirely when the caller supplies both derived values, so the module does
# not require container.clusters.get / compute.subnetworks.get just to build firewall
# rules from values it was handed.
data "google_container_cluster" "this" {
  count    = var.cluster_name != "" && (var.gcp_network_name == "" || var.network_cidr == "") ? 1 : 0
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

locals {
  subnetwork_ref = try(one(data.google_container_cluster.this[*].subnetwork), null)

  # The GKE API always returns networkConfig.subnetwork as a RELATIVE RESOURCE PATH
  # (projects/P/regions/R/subnetworks/NAME): the provider normalizes whatever the
  # config supplied through RelativeLink() before the call and reads the value back
  # from cluster.NetworkConfig.Subnetwork. The field even carries
  # DiffSuppressFunc: CompareSelfLinkOrResourceName precisely because the config and
  # read shapes differ. So this is not "whatever format the cluster was created
  # with" — every cluster with cluster_name set hits the path form.
  #
  # Capture all three segments rather than only the name. The name alone is not
  # enough: google_compute_subnetwork resolves it against the project and region it
  # is given, and the path may legitimately name a different region (a zonal cluster
  # passes its ZONE as gcp_region, since that doubles as the cluster's location) or a
  # different project (Shared VPC, where the subnet lives in the host project).
  # Discarding them turns those cases into a 404.
  #
  # The regex also matches a self_link (the leading (?:.*/)? absorbs the
  # https://www.googleapis.com/compute/v1/ prefix). A bare name matches nothing and
  # falls through to the configured project/region below.
  subnetwork_parts = local.subnetwork_ref == null ? null : try(
    regex("^(?:.*/)?projects/(?P<project>[^/]+)/regions/(?P<region>[^/]+)/subnetworks/(?P<name>[^/]+)$", local.subnetwork_ref),
    null
  )

  cluster_subnetwork_name    = try(local.subnetwork_parts.name, local.subnetwork_ref, "")
  cluster_subnetwork_region  = try(local.subnetwork_parts.region, var.gcp_region)
  cluster_subnetwork_project = try(local.subnetwork_parts.project, var.gcp_project_id)
}

# Get subnetwork info to derive CIDR
data "google_compute_subnetwork" "this" {
  count   = var.cluster_name != "" && var.network_cidr == "" ? 1 : 0
  name    = local.cluster_subnetwork_name
  region  = local.cluster_subnetwork_region
  project = local.cluster_subnetwork_project
}

locals {
  # Derived values from data sources. one() yields null when the data source was
  # skipped, so the override branches below stay reachable.
  # Not coalesce(): it discards empty strings as well as nulls and errors when every
  # argument is empty.
  derived_network_name = try(one(data.google_container_cluster.this[*].network), null)
  derived_subnet_cidr  = try(one(data.google_compute_subnetwork.this[*].ip_cidr_range), null)

  gcp_network_name = local.derived_network_name != null ? local.derived_network_name : ""
  gcp_subnet_cidr  = local.derived_subnet_cidr != null ? local.derived_subnet_cidr : ""

  # Use override if provided, otherwise use derived value.
  # google_compute_firewall.network runs its value through ParseGlobalFieldValue, so
  # a full projects/P/global/networks/N path is accepted here and deliberately left
  # unparsed — only the subnetwork data source lacks that normalization.
  effective_network_name = var.gcp_network_name != "" ? var.gcp_network_name : local.gcp_network_name
  effective_network_cidr = var.network_cidr != "" ? var.network_cidr : local.gcp_subnet_cidr
}

###############################################################################
# PUBLIC GATEWAY
###############################################################################

# Firewall Rules for Public Gateway (GCP/GKE)
# - Port 443 (HTTPS): Open to internet (0.0.0.0/0)
# - Port 15021 (Health Check): Restricted to VPC CIDR + GCP health check ranges
#tfsec:ignore:google-compute-no-public-ingress
resource "google_compute_firewall" "public_gateway_https" {
  count = var.gateways_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-public-https"
  project     = var.gcp_project_id
  network     = local.effective_network_name
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

#tfsec:ignore:google-compute-no-public-ingress
resource "google_compute_firewall" "public_gateway_health_check" {
  count = var.gateways_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-public-health"
  project     = var.gcp_project_id
  network     = local.effective_network_name
  description = "Allow health check traffic from VPC and GCP health checkers to Istio public gateway"

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["15021"]
  }

  # Allow from VPC CIDR and GCP health check ranges
  source_ranges = concat([local.effective_network_cidr], local.gcp_health_check_ranges)
  target_tags   = ["${var.cluster_name}-istio-public-gateway"]
}

# Deny rule for health check from internet (lower priority than allow rule)
#tfsec:ignore:google-compute-no-public-ingress
resource "google_compute_firewall" "public_gateway_deny_health_check" {
  count = var.gateways_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-public-deny-health"
  project     = var.gcp_project_id
  network     = local.effective_network_name
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
  network     = local.effective_network_name
  description = "Allow HTTPS traffic from VPC to Istio private gateway"

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["443"]
  }

  source_ranges = [local.effective_network_cidr]
  target_tags   = ["${var.cluster_name}-istio-private-gateway"]
}

resource "google_compute_firewall" "private_gateway_health_check" {
  count = var.gateway_internal_enabled ? 1 : 0

  name        = "${var.cluster_name}-istio-private-health"
  project     = var.gcp_project_id
  network     = local.effective_network_name
  description = "Allow health check traffic from VPC and GCP health checkers to Istio private gateway"

  direction = "INGRESS"
  priority  = 1000

  allow {
    protocol = "tcp"
    ports    = ["15021"]
  }

  # Allow from VPC CIDR and GCP health check ranges (needed for internal LB)
  source_ranges = concat([local.effective_network_cidr], local.gcp_health_check_ranges)
  target_tags   = ["${var.cluster_name}-istio-private-gateway"]
}
