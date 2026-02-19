# =============================================================================
# Scope Definition - Containers
# =============================================================================
module "scope_definition" {
  source       = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition?ref=v1.34.0"
  nrn          = var.nrn
  np_api_key   = var.np_api_key
  service_path = var.service_path
}

# =============================================================================
# Dimensions
# =============================================================================
module "dimensions" {
  source       = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/dimensions?ref=v1.34.0"
  nrn          = var.nrn
  np_api_key   = var.np_api_key
  environments = var.environments
}
