resource "nullplatform_provider_config" "prometheus" {
  nrn  = var.nrn
  type = "prometheus"
  attributes = jsonencode({
    "server" : {
      "url" = local.prometheus_server_url
    }
  })
  dimensions = var.dimensions

  lifecycle {
    ignore_changes = [attributes]
  }
}
