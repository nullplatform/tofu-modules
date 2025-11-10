locals {
  helm_values = templatefile("${path.module}/templates/cert_manager_values.tmpl.yaml", {
    hosted_zone_name = var.hosted_zone_name
    account_slug     = var.account_slug
    namespace        = var.cert_manager_namespace

    # GCP
    gcp_enabled             = var.gcp_enabled
    gcp_service_account_key = coalesce(var.gcp_service_account_key, "")

    # Azure
    azure_enabled             = var.azure_enabled
    azure_subscription_id     = coalesce(var.azure_subscription_id, "")
    azure_resource_group_name = coalesce(var.azure_resource_group_name, "")
    azure_client_id           = coalesce(var.azure_client_id, "")
    azure_secret_key          = coalesce(var.azure_secret_key, "client-secret")
    azure_client_secret       = coalesce(var.azure_client_secret, "")
    azure_tenant_id           = coalesce(var.azure_tenant_id, "")
    azure_hosted_zone_name    = coalesce(var.azure_hosted_zone_name, "")

    # Cloudflare
    cloudflare_enabled     = var.cloudflare_enabled
    cloudflare_secret_name = var.cloudflare_secret_name
    cloudflare_token       = var.cloudflare_token
  })
}