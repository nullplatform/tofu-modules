locals {
  # La API rechaza un hosted_public_zone_id vacío, así que solo se incluye
  # cuando tiene valor — esto habilita instalaciones private-only.
  networking = merge(
    {
      application_domain = var.application_domain,
      domain_name        = var.domain_name
      hosted_zone_id     = var.hosted_private_zone_id
    },
    var.hosted_public_zone_id != null && var.hosted_public_zone_id != "" ? { hosted_public_zone_id = var.hosted_public_zone_id } : {}
  )
}