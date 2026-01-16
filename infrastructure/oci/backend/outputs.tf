output "bucket_name" {
  description = "Nombre del bucket creado"
  value       = oci_objectstorage_bucket.tofu_state.name
}

output "bucket_id" {
  description = "OCID del bucket"
  value       = oci_objectstorage_bucket.tofu_state.bucket_id
}

output "namespace" {
  description = "Object Storage namespace"
  value       = oci_objectstorage_bucket.tofu_state.namespace
}

output "bucket_endpoint" {
  description = "Endpoint del bucket para configurar el backend"
  value       = "https://${var.namespace}.compat.objectstorage.${data.oci_identity_region_subscriptions.regions.region_subscriptions[0].region_name}.oraclecloud.com"
}

output "backend_config" {
  description = "Configuración sugerida para el backend de OpenTofu"
  value       = <<-EOT
    terraform {
      backend "s3" {
        bucket                      = "${oci_objectstorage_bucket.tofu_state.name}"
        key                         = "terraform.tfstate"
        region                      = "${data.oci_identity_region_subscriptions.regions.region_subscriptions[0].region_name}"
        endpoint                    = "https://${var.namespace}.compat.objectstorage.${data.oci_identity_region_subscriptions.regions.region_subscriptions[0].region_name}.oraclecloud.com"
        skip_region_validation      = true
        skip_credentials_validation = true
        skip_requesting_account_id  = true
        skip_metadata_api_check     = true
        skip_s3_checksum            = true
        use_path_style              = true
      }
    }
  EOT
}
