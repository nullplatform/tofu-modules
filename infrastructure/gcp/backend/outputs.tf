output "bucket_name" {
  description = "Name of the GCS bucket for Terraform/OpenTofu state"
  value       = google_storage_bucket.tf_state.name
}

output "bucket_url" {
  description = "gs:// URL of the GCS bucket"
  value       = google_storage_bucket.tf_state.url
}

output "bucket_self_link" {
  description = "Self-link of the GCS bucket"
  value       = google_storage_bucket.tf_state.self_link
}

output "location" {
  description = "Location of the GCS bucket"
  value       = google_storage_bucket.tf_state.location
}

output "log_bucket_name" {
  description = "Name of the bucket receiving access logs — either var.log_bucket, or the module's own auto-created log bucket when that's left unset"
  value       = local.effective_log_bucket
}
