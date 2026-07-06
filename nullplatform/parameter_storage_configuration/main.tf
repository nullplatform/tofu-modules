module "config" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_configuration?ref=v6.1.0"

  nrn                         = var.nrn
  np_api_key                  = var.np_api_key
  provider_specification_slug = var.provider_specification_slug
  dimensions                  = var.dimensions
  attributes                  = var.attributes
}
