locals {
  cert_manager_default_values = yamlencode({
    hostedZoneName = var.hosted_zone_name
    nullPlatform = {
      accountSlug = var.account_slug
    }
    namespacecontroller = {
      name = var.cert_manager_namespace
    }
  })

  cert_manager_gcp_values = yamlencode({
    gcp = {
      enabled           = var.gcp_enabled
      serviceAccountKey = var.gcp_service_account_key != null ? var.gcp_service_account_key : ""
    }
  })

  cert_manager_cloudfare_values = yamlencode({
    cloudflare = {
      enabled    = var.cloudflare_enabled
      secretName = var.cloudflare_secret_name
      apiToken   = var.cloudflare_token
    }
  })

  cert_manager_azure_values = yamlencode({
    azure = {
      enabled           = var.azure_enabled
      subscriptionID    = var.azure_subscription_id != null ? var.azure_subscription_id : ""
      resourceGroupName = var.azure_resource_group_name != null ? var.azure_resource_group_name : ""
      clientID          = var.azure_client_id != null ? var.azure_client_id : ""
      secretKey         = var.azure_secret_key != null ? var.azure_secret_key : "client-secret"
      clientSecret      = var.azure_client_secret != null ? var.azure_client_secret : ""
      tenantID          = var.azure_tenant_id != null ? var.azure_tenant_id : ""
      hostedZoneName    = var.azure_hosted_zone_name != null ? var.azure_hosted_zone_name : ""
    }
  })

  cert_manager_aws_values = yamlencode({
    aws = {
      enabled      = var.aws_enabled
      region       = var.aws_region
      hostedZoneID = var.aws_hosted_zone_id
      serviceAccount = {
        annotations = {
          "eks.amazonaws.com/role-arn" = var.aws_role_arn
        }
      }
    }
  })
}