resource "nullplatform_provider_config" "s3" {
  provider   = nullplatform
  nrn        = var.nrn
  type       = "s3-configuration"
  dimensions = var.dimensions
  attributes = jsonencode({
    bucket = {
      name = var.bucket_name
    }
  })
}
