module "cloud_aws_agent" {
  source                              = "git::https://github.com/nullplatform/tofu-modules.git//nullplatform/agent?ref=fix/cert-manager-config"

  cloud_provider = ""
  cluster_name   = ""
  image_tag      = ""
  nrn            = ""
  tags_selectors = {}
  private_hosted_zone_rg = var.private_hosted_zone_rg
  private_gateway_name   = var.private_gateway_name
  public_gateway_name    = var.public_gateway_name
  azure_resource_group   = var.azure_resource_group
  azure_subscription_id  = var.azure_subscription_id
  azure_client_secret    = var.azure_client_secret
  azure_client_id        = var.azure_client_id
  azure_tenant_id        = var.azure_tenant_id
}

module "cert_manager" {
  source                       = "git::https://github.com/nullplatform/tofu-modules.git///infrastructure/commons/cert_manager?ref=fix/cert-manager-config"
  account_slug                 = ""
  azure_subscription_id        = ""
  hosted_zone_name             = ""
  cloudflare_enabled = ""
  cloudflare_secret_name = ""
  cloudflare_token = ""
}