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