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