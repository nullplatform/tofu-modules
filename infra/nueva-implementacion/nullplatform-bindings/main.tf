# =============================================================================
# Code Repository (GitHub)
# =============================================================================
module "code_repository" {
  source                 = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/code_repository?ref=v1.34.0"
  git_provider           = "github"
  np_api_key             = var.np_api_key
  nrn                    = var.nrn
  github_organization    = var.github_organization
  github_installation_id = var.github_installation_id
}

# =============================================================================
# Asset Repository (ECR)
# =============================================================================
module "asset_repository" {
  source       = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/asset/ecr?ref=v1.34.0"
  nrn          = var.nrn
  np_api_key   = var.np_api_key
  cluster_name = local.eks_cluster_name
}

# =============================================================================
# Cloud Provider (AWS)
# =============================================================================
module "cloud_provider" {
  source                 = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/cloud/aws/cloud?ref=v1.34.0"
  nrn                    = var.nrn
  np_api_key             = var.np_api_key
  domain_name            = var.domain_name
  hosted_private_zone_id = local.private_zone_id
  hosted_public_zone_id  = local.public_zone_id
}

# =============================================================================
# API Key (Scope Notification)
# =============================================================================
module "scope_notification_api_key" {
  source             = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.34.0"
  type               = "scope_notification"
  nrn                = var.nrn
  specification_slug = local.scope_specification_slug
}

# =============================================================================
# Scope Definition Agent Association
# =============================================================================
module "scope_definition_agent_association" {
  source                   = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/scope_definition_agent_association?ref=v1.34.0"
  nrn                      = var.nrn
  api_key                  = module.scope_notification_api_key.api_key
  tags_selectors           = var.tags_selectors
  scope_specification_id   = local.scope_specification_id
  scope_specification_slug = local.scope_specification_slug
}

# =============================================================================
# Monitoring Provider (Metrics)
# =============================================================================
module "monitoring_provider" {
  source     = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/metrics?ref=v1.34.0"
  nrn        = var.nrn
  np_api_key = var.np_api_key
}
