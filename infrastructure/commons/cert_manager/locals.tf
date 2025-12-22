locals {
  cert_manager_default_values = templatefile("${path.module}/templates/cert_manager_default_values.tmpl.yaml", {
    hosted_zone_name = var.hosted_zone_name
    account_slug     = var.account_slug
    namespace        = var.cert_manager_namespace
  })

  cert_manager_gcp_values = templatefile("${path.module}/templates/cert_manager_gcp_values.tmpl.yaml", {
    # GCP
    gcp_enabled             = var.gcp_enabled
    gcp_service_account_key = var.gcp_service_account_key != null ? var.gcp_service_account_key : ""
  })

  cert_manager_cloudfare_values = templatefile("${path.module}/templates/cert_manager_cloudfare_values.tmpl.yaml", {
    # Cloudflare
    cloudflare_enabled     = var.cloudflare_enabled
    cloudflare_secret_name = var.cloudflare_secret_name
    cloudflare_token       = var.cloudflare_token
  })

  cert_manager_azure_values = templatefile("${path.module}/templates/cert_manager_azure_values.tmpl.yaml", {
    # Azure
    azure_enabled             = var.azure_enabled
    azure_subscription_id     = var.azure_subscription_id != null ? var.azure_subscription_id : ""
    azure_resource_group_name = var.azure_resource_group_name != null ? var.azure_resource_group_name : ""
    azure_client_id           = var.azure_client_id != null ? var.azure_client_id : ""
    azure_secret_key          = var.azure_secret_key != null ? var.azure_secret_key : "client-secret"
    azure_client_secret       = var.azure_client_secret != null ? var.azure_client_secret : ""
    azure_tenant_id           = var.azure_tenant_id != null ? var.azure_tenant_id : ""
    azure_hosted_zone_name    = var.azure_hosted_zone_name != null ? var.azure_hosted_zone_name : ""
  })

  ###############################################################################
  # CERT-MANAGER
  ###############################################################################
  base_annotations = {
    "{{ .Chart.Name }}-helm-chart/version" = "{{ .Chart.Version }}"
  }

  annotations_by_provider = {
    gcp = {
      "iam.gke.io/gcp-service-account" = var.gcp_sa_email
    }

    aws = {

      "eks.amazonaws.com/role-arn" = var.aws_sa_arn
    }

    azure = {
      "azure.workload.identity/client-id" = var.azure_client_id
    }
  }

  cert_manager_values = {
    cdrs = {
      enabled = true
    }
    serviceAccount = {
      create = true
      annotations = merge(
        local.base_annotations,
        lookup(local.annotations_by_provider, var.cloud_provider, {})
    ) }
    dns01RecursiveNameservers = "8.8.8.8:53,1.1.1.1:53"
    dns01RecursiveNameserversOnly : true
  }

}
