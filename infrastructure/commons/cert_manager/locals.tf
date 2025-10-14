locals {
  helm_values = templatefile("${path.module}/templates/cert_manager_values.tmpl.yaml", {
    hosted_zone_name = var.hosted_zone_name
    account_slug     = var.account_slug

    # GCP
    gcp_enabled             = var.gcp_enabled
    gcp_service_account_key = var.gcp_service_account_key

    # Azure
    azure_enabled             = var.azure_enabled
    azure_subscription_id     = var.azure_subscription_id
    azure_resource_group_name = var.azure_resource_group_name
    azure_client_id           = var.azure_client_id
    azure_secret_key          = var.azure_secret_key
    azure_client_secret       = var.azure_client_secret
    azure_tenant_id           = var.azure_tenant_id
    azure_hosted_zone_name    = var.azure_hosted_zone_name

    # Cloudflare
    cloudflare_enabled     = var.cloudflare_enabled
    cloudflare_secret_name = var.cloudflare_secret_name
    cloudflare_token       = var.cloudflare_token
  })
}