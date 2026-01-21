data "oci_identity_region_subscriptions" "regions" {
  tenancy_id = var.compartment_id
}
