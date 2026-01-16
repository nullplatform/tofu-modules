# -----------------------------------------------------------------------
# VCN Outputs
# -----------------------------------------------------------------------
output "vcn_id" {
  description = "The OCID of the VCN"
  value       = module.vcn.vcn_id
}

output "vcn_all_attributes" {
  description = "All attributes of the VCN"
  value       = module.vcn.vcn_all_attributes
}

output "view_id" {
  description = "The OCID of the DNS private view"
  value       = module.vcn.vcn_all_attributes.default_view_id
}

output "default_security_list_id" {
  description = "The OCID of the default security list"
  value       = module.vcn.default_security_list_id
}

# -----------------------------------------------------------------------
# Gateway Outputs
# -----------------------------------------------------------------------
output "internet_gateway_id" {
  description = "The OCID of the Internet Gateway"
  value       = module.vcn.internet_gateway_id
}

output "nat_gateway_id" {
  description = "The OCID of the NAT Gateway"
  value       = module.vcn.nat_gateway_id
}

output "service_gateway_id" {
  description = "The OCID of the Service Gateway"
  value       = module.vcn.service_gateway_id
}

# -----------------------------------------------------------------------
# Route Table Outputs
# -----------------------------------------------------------------------
output "ig_route_id" {
  description = "The OCID of the Internet Gateway route table"
  value       = module.vcn.ig_route_id
}

output "nat_route_id" {
  description = "The OCID of the NAT Gateway route table"
  value       = module.vcn.nat_route_id
}

output "sgw_route_id" {
  description = "The OCID of the Service Gateway route table"
  value       = module.vcn.sgw_route_id
}

# -----------------------------------------------------------------------
# Public Subnet Outputs
# -----------------------------------------------------------------------
output "public_subnet_id" {
  description = "The OCID of the public subnet"
  value       = oci_core_subnet.public_subnet.id
}

output "public_subnet_cidr_block" {
  description = "The CIDR block of the public subnet"
  value       = oci_core_subnet.public_subnet.cidr_block
}

output "public_subnet_display_name" {
  description = "The display name of the public subnet"
  value       = oci_core_subnet.public_subnet.display_name
}

# -----------------------------------------------------------------------
# Private Subnet Outputs
# -----------------------------------------------------------------------
output "private_subnet_id" {
  description = "The OCID of the private subnet"
  value       = oci_core_subnet.private_subnet.id
}

output "private_subnet_cidr_block" {
  description = "The CIDR block of the private subnet"
  value       = oci_core_subnet.private_subnet.cidr_block
}

output "private_subnet_display_name" {
  description = "The display name of the private subnet"
  value       = oci_core_subnet.private_subnet.display_name
}
