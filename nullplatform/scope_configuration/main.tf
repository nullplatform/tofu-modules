resource "nullplatform_provider_config" "scope_configuration" {
  nrn        = var.nrn
  type       = "static-files"
  dimensions = var.dimensions

  attributes = jsonencode(merge(local.defaults, {
    cloud_provider = var.cloud_provider
    provider = {
      aws_region       = var.aws_region
      aws_state_bucket = var.aws_state_bucket
    }
    distribution = merge(local.defaults.distribution, { aws_distribution = var.aws_distribution })
    network = merge(local.defaults.network, {
      aws_network               = var.aws_network
      aws_hosted_public_zone_id = var.aws_hosted_public_zone_id
    })
    security = merge(local.defaults.security, {
      aws_security     = var.aws_security
      aws_web_acl_name = var.aws_web_acl_name
    })
  }))
}
