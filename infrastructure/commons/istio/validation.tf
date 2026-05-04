resource "terraform_data" "provider_validation" {
  lifecycle {
    precondition {
      condition     = var.cloud_provider != "oci" || length(var.oci_load_balancer_subnet_ids) > 0
      error_message = "oci_load_balancer_subnet_ids is required when cloud_provider is 'oci'."
    }
  }
}
