# =============================================================================
# VPC
# =============================================================================
module "vpc" {
  source       = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/vpc?ref=v1.34.0"
  vpc          = var.vpc
  organization = var.organization
  account      = var.account
}

# =============================================================================
# EKS
# =============================================================================
module "eks" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/eks?ref=v1.34.0"
  name                         = var.eks_cluster_name
  aws_vpc_vpc_id               = module.vpc.vpc_id
  aws_subnets_private_ids      = module.vpc.private_subnets
  instance_types               = var.eks_instance_types
  kubernetes_version           = var.eks_kubernetes_version
  endpoint_public_access       = var.endpoint_public_access
  endpoint_public_access_cidrs = var.endpoint_public_access_cidrs
}

# =============================================================================
# Route53 DNS Zones
# =============================================================================
module "route53" {
  source      = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/route53?ref=v1.34.0"
  vpc_id      = module.vpc.vpc_id
  domain_name = var.domain_name
}

# =============================================================================
# ALB Controller
# =============================================================================
module "alb_controller" {
  source                          = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/alb_controller?ref=v1.34.0"
  cluster_name                    = module.eks.eks_cluster_name
  vpc_id                          = module.vpc.vpc_id
  aws_iam_openid_connect_provider = module.eks.eks_oidc_provider_arn
}

# =============================================================================
# Istio
# =============================================================================
module "istio" {
  source     = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/istio?ref=v1.34.0"
  depends_on = [module.alb_controller]
}

# =============================================================================
# Prometheus
# =============================================================================
module "prometheus" {
  source     = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/prometheus?ref=v1.34.0"
  depends_on = [module.alb_controller]
}

# =============================================================================
# External DNS IAM
# =============================================================================
module "external_dns_iam" {
  source                              = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/external_dns?ref=v1.34.0"
  cluster_name                        = module.eks.eks_cluster_name
  aws_iam_openid_connect_provider_arn = module.eks.eks_oidc_provider_arn
  hosted_zone_public_id               = module.route53.public_zone_id
  hosted_zone_private_id              = module.route53.private_zone_id
}

# =============================================================================
# External DNS Public
# =============================================================================
module "external_dns_public" {
  source            = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v1.34.0"
  dns_provider_name = "aws"
  aws_region        = var.aws_region
  aws_iam_role_arn  = module.external_dns_iam.nullplatform_external_dns_role_arn
  domain_filters    = var.domain_name
  zone_id_filter    = module.route53.public_zone_id
  zone_type         = "public"
  type              = "public"
  depends_on        = [module.alb_controller]
}

# =============================================================================
# External DNS Private
# =============================================================================
module "external_dns_private" {
  source            = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/external_dns?ref=v1.34.0"
  dns_provider_name = "aws"
  aws_region        = var.aws_region
  aws_iam_role_arn  = module.external_dns_iam.nullplatform_external_dns_role_arn
  domain_filters    = var.domain_name
  zone_id_filter    = module.route53.private_zone_id
  zone_type         = "private"
  type              = "private"
  create_namespace  = false
  depends_on        = [module.alb_controller, module.external_dns_public]
}

# =============================================================================
# Cert Manager IAM
# =============================================================================
module "cert_manager_iam" {
  source                              = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/cert_manager?ref=v1.34.0"
  cluster_name                        = module.eks.eks_cluster_name
  aws_iam_openid_connect_provider_arn = module.eks.eks_oidc_provider_arn
  hosted_zone_public_id               = module.route53.public_zone_id
  hosted_zone_private_id              = module.route53.private_zone_id
}

# =============================================================================
# Cert Manager
# =============================================================================
module "cert_manager" {
  source              = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/commons/cert_manager?ref=v1.34.0"
  cloud_provider      = "aws"
  aws_region          = var.aws_region
  aws_sa_arn          = module.cert_manager_iam.nullplatform_cert_manager_role_arn
  private_domain_name = module.route53.private_zone_name
  hosted_zone_name    = module.route53.public_zone_name
  account_slug        = var.account
  depends_on          = [module.alb_controller]
}

# =============================================================================
# Agent IAM
# =============================================================================
module "agent_iam" {
  source                              = "git::https://github.com/nullplatform/tofu-modules.git//infrastructure/aws/iam/agent?ref=v1.34.0"
  cluster_name                        = module.eks.eks_cluster_name
  aws_iam_openid_connect_provider_arn = module.eks.eks_oidc_provider_arn
  agent_namespace                     = var.agent_namespace
}

# =============================================================================
# API Key (Agent)
# =============================================================================
module "agent_api_key" {
  source = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/api_key?ref=v1.34.0"
  type   = "agent"
  nrn    = var.nrn
}

# =============================================================================
# Nullplatform Base
# =============================================================================
module "base" {
  source                    = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/base?ref=v1.34.0"
  nrn                       = var.nrn
  np_api_key                = module.agent_api_key.api_key
  k8s_provider              = var.k8s_provider
  aws_region                = var.aws_region
  gateway_enabled           = var.gateway_enabled
  gateway_internal_enabled  = var.gateway_internal_enabled
  gateways_enabled          = var.gateways_enabled
  gateway_public_aws_name   = var.gateway_public_aws_name
  gateway_internal_aws_name = var.gateway_internal_aws_name
  prometheus_enabled        = var.prometheus_enabled
  depends_on                = [module.alb_controller]
}

# =============================================================================
# Nullplatform Agent
# =============================================================================
module "agent" {
  source                  = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=v1.34.0"
  api_key                 = module.agent_api_key.api_key
  cluster_name            = module.eks.eks_cluster_name
  nrn                     = var.nrn
  tags_selectors          = var.tags_selectors
  cloud_provider          = var.agent_cloud_provider
  dns_type                = var.agent_dns_type
  image_tag               = var.agent_image_tag
  aws_iam_role_arn        = module.agent_iam.nullplatform_agent_role_arn
  use_account_slug        = var.agent_use_account_slug
  image_pull_secrets      = var.agent_image_pull_secrets
  service_template        = var.agent_service_template
  initial_ingress_path    = var.agent_initial_ingress_path
  blue_green_ingress_path = var.agent_blue_green_ingress_path
  depends_on              = [module.base]
}
