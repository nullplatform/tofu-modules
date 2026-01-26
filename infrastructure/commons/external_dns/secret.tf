resource "kubernetes_secret_v1" "external_dns_cloudflare" {
  count = var.dns_provider_name == "cloudflare" ? 1 : 0
  metadata {
    name      = "external-dns-cloudflare"
    namespace = var.external_dns_namespace
  }
  type = "Opaque"
  data = {
    "api-token" = var.cloudflare_token
  }

  depends_on = [kubernetes_namespace_v1.external_dns]
}

resource "kubernetes_secret_v1" "external_dns_azure" {
  count = var.dns_provider_name == "azure" && !var.azure_use_workload_identity ? 1 : 0

  metadata {
    name      = "external-dns-azure"
    namespace = var.external_dns_namespace
  }

  type = "Opaque"
  data = {
    "azure.json" = jsonencode({
      tenantId                    = var.azure_tenant_id
      subscriptionId              = var.azure_subscription_id
      resourceGroup               = var.azure_resource_group
      aadClientId                 = var.azure_client_id
      aadClientSecret             = var.azure_client_secret
      useManagedIdentityExtension = false
    })
  }

  depends_on = [kubernetes_namespace_v1.external_dns]
}

resource "kubernetes_secret_v1" "external_dns_oci_config" {
  count = var.dns_provider_name == "oci" ? 1 : 0

  metadata {
    name      = "external-dns-config"
    namespace = var.external_dns_namespace
  }

  data = {
    "oci.yaml" = <<-EOT
auth:
  region: ${var.oci_region}
  useWorkloadIdentity: true
compartment: ${var.oci_compartment_ocid}
EOT
  }

  depends_on = [kubernetes_namespace_v1.external_dns]
}