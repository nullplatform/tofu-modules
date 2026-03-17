# -----------------------------------------------------------------------
# 1. VNC module
# -----------------------------------------------------------------------
module "vcn" {
  source         = "oracle-terraform-modules/vcn/oci"
  version        = "3.6.0"
  compartment_id = var.compartment_id
  region         = var.region
  vcn_name       = var.vcn_name
  vcn_dns_label  = var.vcn_dns_label
  vcn_cidrs      = var.vcn_cidrs
  # GATEWAYS
  create_internet_gateway = var.create_internet_gateway
  create_nat_gateway      = var.create_nat_gateway
  create_service_gateway  = var.create_service_gateway
}

# -----------------------------------------------------------------------
# 2. SUBNETS
# -----------------------------------------------------------------------

# Public
resource "oci_core_subnet" "public_subnet" {
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  cidr_block     = var.subnet_public_cidr_block
  display_name   = var.subnet_public_display_name

  route_table_id = module.vcn.ig_route_id

  security_list_ids = [module.vcn.default_security_list_id]
}

# Private
resource "oci_core_subnet" "private_subnet" {
  compartment_id             = var.compartment_id
  vcn_id                     = module.vcn.vcn_id
  cidr_block                 = var.subnet_private_cidr_block
  display_name               = var.subnet_private_display_name
  prohibit_public_ip_on_vnic = var.subnet_private_prohibit_public_ip_on_vnic

  route_table_id = module.vcn.nat_route_id

  security_list_ids = [module.vcn.default_security_list_id]
}

# Pod Subnet
resource "oci_core_subnet" "pod_subnet" {
  count                      = var.cni_type == "npn" ? 1 : 0
  compartment_id             = var.compartment_id
  vcn_id                     = module.vcn.vcn_id
  cidr_block                 = var.subnet_pod_cidr_block
  display_name               = var.subnet_pod_display_name
  dns_label                  = "pods"
  prohibit_public_ip_on_vnic = true
  route_table_id             = module.vcn.nat_route_id
  security_list_ids          = [module.vcn.default_security_list_id]
}

# -----------------------------------------------------------------------
# 3. OKE Control Plane NSG
# -----------------------------------------------------------------------
resource "oci_core_network_security_group" "oke_control_plane" {
  count          = var.create_oke_control_plane_nsg ? 1 : 0
  compartment_id = var.compartment_id
  vcn_id         = module.vcn.vcn_id
  display_name   = "${var.vcn_name}-oke-control-plane-nsg"
}

# Allow inbound traffic to Kubernetes API (port 6443) from specified CIDRs
resource "oci_core_network_security_group_security_rule" "oke_api_ingress" {
  for_each                  = var.create_oke_control_plane_nsg ? toset(var.oke_api_endpoint_allowed_cidrs) : []
  network_security_group_id = oci_core_network_security_group.oke_control_plane[0].id
  direction                 = "INGRESS"
  protocol                  = "6" # TCP
  source                    = each.value
  source_type               = "CIDR_BLOCK"

  tcp_options {
    destination_port_range {
      min = 6443
      max = 6443
    }
  }
}

# Allow all egress traffic from control plane
resource "oci_core_network_security_group_security_rule" "oke_control_plane_egress" {
  count                     = var.create_oke_control_plane_nsg ? 1 : 0
  network_security_group_id = oci_core_network_security_group.oke_control_plane[0].id
  direction                 = "EGRESS"
  protocol                  = "all"
  destination               = "0.0.0.0/0"
  destination_type          = "CIDR_BLOCK"
}

# Allow all ingress traffic from VCN CIDR (for internal cluster communication)
resource "oci_core_network_security_group_security_rule" "oke_vcn_ingress" {
  for_each                  = var.create_oke_control_plane_nsg ? toset(var.vcn_cidrs) : []
  network_security_group_id = oci_core_network_security_group.oke_control_plane[0].id
  direction                 = "INGRESS"
  protocol                  = "all"
  source                    = each.value
  source_type               = "CIDR_BLOCK"
}
