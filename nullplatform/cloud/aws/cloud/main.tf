locals {
  # La API de nullplatform valida hosted_public_zone_id con ^Z[A-Z0-9]{10,}$
  # (verificado empíricamente) y rechaza el string vacío. Se incluye en el payload
  # sólo cuando tiene valor → habilita instalaciones private-only (sin zona pública).
  # El guard != null es defensivo (el default es "", pero un módulo caller podría
  # pasar null explícitamente); la API no distingue null de "".
  networking = merge(
    {
      application_domain = var.application_domain,
      domain_name        = var.domain_name
      hosted_zone_id     = var.hosted_private_zone_id
    },
    var.hosted_public_zone_id != null && var.hosted_public_zone_id != "" ? { hosted_public_zone_id = var.hosted_public_zone_id } : {}
  )
}

resource "nullplatform_provider_config" "aws" {
  provider   = nullplatform
  nrn        = var.nrn
  type       = "aws-configuration"
  dimensions = var.dimensions
  attributes = jsonencode({
    account = {
      id     = data.aws_caller_identity.current.id
      region = data.aws_region.current.region
    }
    networking = local.networking
  })
}
